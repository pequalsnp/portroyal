package modules

import _root_.services.UserService
import com.google.inject.{Provides, AbstractModule}
import com.mohiva.play.silhouette.api.repositories.{AuthInfoRepository, AuthenticatorRepository}
import com.mohiva.play.silhouette.api.services.AuthenticatorService
import com.mohiva.play.silhouette.api.util._
import com.mohiva.play.silhouette.api._
import com.mohiva.play.silhouette.impl.authenticators.{JWTAuthenticatorService, JWTAuthenticatorSettings, JWTAuthenticator}
import com.mohiva.play.silhouette.impl.providers.CredentialsProvider
import com.mohiva.play.silhouette.impl.util.{DefaultFingerprintGenerator, SecureRandomIDGenerator, PlayCacheLayer}
import com.mohiva.play.silhouette.password.BCryptPasswordHasher
import models.SilhouetteEnvironment
import net.codingwell.scalaguice.ScalaModule
import play.api.Configuration
import play.api.libs.concurrent.Execution.Implicits._
import play.api.libs.ws.WSClient
import stores.{InMemoryUserStore, UserStore}

class SilhouetteModule extends AbstractModule with ScalaModule {
  def configure(): Unit = {
    bind[Silhouette[SilhouetteEnvironment]].to[SilhouetteProvider[SilhouetteEnvironment]]
    bind[CacheLayer].to[PlayCacheLayer]
    bind[IDGenerator].toInstance(new SecureRandomIDGenerator())
    bind[PasswordHasher].toInstance(new BCryptPasswordHasher)
    bind[FingerprintGenerator].toInstance(new DefaultFingerprintGenerator(false))
    bind[EventBus].toInstance(EventBus())
    bind[Clock].toInstance(Clock())
    bind[UserStore].to[InMemoryUserStore]
  }

  @Provides
  def provideHTTPLayer(client: WSClient): HTTPLayer = {
    new PlayHTTPLayer(client)
  }

  @Provides
  def provideEnvironment(
    userService: UserService,
    authenticatorService: AuthenticatorService[JWTAuthenticator],
    eventBus: EventBus
  ): Environment[SilhouetteEnvironment] = {

    Environment[SilhouetteEnvironment](
      userService,
      authenticatorService,
      Seq(),
      eventBus
    )
  }

  @Provides
  def provideAuthenticatorService(
    idGenerator: IDGenerator,
    configuration: Configuration,
    clock: Clock
  ): AuthenticatorService[JWTAuthenticator] = {
    val config = JWTAuthenticatorSettings(sharedSecret = "changeme")
    new JWTAuthenticatorService(config, None, idGenerator, clock)
  }

  @Provides
  def provideCredentialsProvider(
    authInfoRepository: AuthInfoRepository,
    passwordHasher: PasswordHasher): CredentialsProvider = {

    new CredentialsProvider(authInfoRepository, passwordHasher, Seq(passwordHasher))
  }
}
