package stores

import com.google.inject.Singleton
import com.mohiva.play.silhouette.api.LoginInfo
import models.User

import scala.collection.mutable
import scala.concurrent.Future

@Singleton
class InMemoryUserStore extends UserStore {
  val users = mutable.Map.empty[LoginInfo, User]

  def save(user: User): Future[User] = {
    users += (user.loginInfo -> user)
    Future.successful(user)
  }

  def find(loginInfo: LoginInfo): Future[Option[User]] = {
    Future.successful(users.get(loginInfo))
  }
}
