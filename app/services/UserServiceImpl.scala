package services

import com.google.inject.Inject
import com.mohiva.play.silhouette.api.LoginInfo
import models.User
import stores.UserStore

import scala.concurrent.Future

class UserServiceImpl @Inject()(userStore: UserStore) extends UserService {
  override def retrieve(loginInfo: LoginInfo): Future[Option[User]] = {
    userStore.find(loginInfo)
  }

  def save(user: User): Future[User] = {
    userStore.save(user)
  }
}
