package controllers

import java.util.UUID
import javax.inject.Inject

import com.google.inject.Singleton
import com.mohiva.play.silhouette.api.{LoginInfo, Silhouette}
import com.mohiva.play.silhouette.api.repositories.AuthInfoRepository
import com.mohiva.play.silhouette.api.util.{Credentials, PasswordHasher}
import com.mohiva.play.silhouette.impl.providers.CredentialsProvider
import models.{User, SilhouetteEnvironment}
import models.forms.{LoginUserForm, CreateUserForm}
import play.api.i18n.{MessagesApi, I18nSupport}
import play.api.libs.json.Json
import play.api.mvc._
import services.UserService

import scala.concurrent.{Future, ExecutionContext}

@Singleton
class UserAuthController @Inject()(
  val messagesApi: MessagesApi,
  silhouette: Silhouette[SilhouetteEnvironment],
  userService: UserService,
  authInfoRepository: AuthInfoRepository,
  passwordHasher: PasswordHasher,
  credentialsProvider: CredentialsProvider
)(implicit exec: ExecutionContext) extends Controller with I18nSupport {

  def createUser = silhouette.UnsecuredAction.async(BodyParsers.parse.json) { implicit request =>
    CreateUserForm.form.bind(request.body).fold(
      formWithErrors => Future.successful(BadRequest(formWithErrors.errorsAsJson)),
      validatedForm => {
        val loginInfo = LoginInfo(CredentialsProvider.ID, validatedForm.userName)
        userService.retrieve(loginInfo).flatMap {
          case Some(user) =>
            Future.successful(BadRequest("User exists"))
          case _ => {
            val hashedPassword = passwordHasher.hash(validatedForm.password)
            val newUser = User(
              id = UUID.randomUUID.toString,
              loginInfo = loginInfo,
              userName = validatedForm.userName,
              displayName = validatedForm.displayName
            )
            for {
              user <- userService.save(newUser)
              authInfo <- authInfoRepository.add(loginInfo, hashedPassword)
              authenticator <- silhouette.env.authenticatorService.create(loginInfo)
              jwt <- silhouette.env.authenticatorService.init(authenticator)
            } yield {
              Ok(
                Json.obj(
                  "displayName" -> user.displayName,
                  "jwt" -> jwt
                )
              )
            }
          }
        }
      }
    )
  }

  def loginUser = silhouette.UnsecuredAction.async(BodyParsers.parse.json) { implicit request =>
    LoginUserForm.form.bind(request.body).fold(
      formWithErrors => Future.successful(BadRequest(formWithErrors.errorsAsJson)),
      validatedForm => {
        val credentials = Credentials(validatedForm.userName, validatedForm.password)
        credentialsProvider.authenticate(credentials).flatMap { loginInfo: LoginInfo =>
          userService.retrieve(loginInfo).flatMap {
            case Some(user) => for {
              authenticator <- silhouette.env.authenticatorService.create(loginInfo)
              jwt <- silhouette.env.authenticatorService.init(authenticator)
            } yield {
              Ok(
                Json.obj(
                  "displayName" -> user.displayName,
                  "jwt" -> jwt
                )
              )
            }
          }
        }
      }
    )
  }
}
