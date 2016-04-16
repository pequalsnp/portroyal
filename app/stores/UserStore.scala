package stores

import com.mohiva.play.silhouette.api.LoginInfo
import models.User
import scala.concurrent.Future

trait UserStore {
  def find(loginInfo: LoginInfo): Future[Option[User]]
  def save(user: User): Future[User]
}
