package services

import com.mohiva.play.silhouette.api.services.IdentityService
import models.User

import scala.concurrent.Future

trait UserService extends IdentityService[User] {
  def save(user: User): Future[User]
}
