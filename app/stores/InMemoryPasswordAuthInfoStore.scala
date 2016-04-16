package stores

import com.google.inject.Inject
import com.mohiva.play.silhouette.api.LoginInfo
import com.mohiva.play.silhouette.api.util.PasswordInfo
import com.mohiva.play.silhouette.persistence.daos.DelegableAuthInfoDAO

import scala.collection.mutable
import scala.concurrent.Future

/**
  * Created by kyles on 4/16/2016.
  */
class InMemoryPasswordAuthInfoStore @Inject()() extends DelegableAuthInfoDAO[PasswordInfo] {
  val store = mutable.Map.empty[LoginInfo, PasswordInfo]

  override def find(loginInfo: LoginInfo): Future[Option[PasswordInfo]] = {
    Future.successful(store.get(loginInfo))
  }

  override def save(loginInfo: LoginInfo, passwordInfo: PasswordInfo): Future[PasswordInfo] = {
    store += (loginInfo -> passwordInfo)
    Future.successful(passwordInfo)
  }

  override def update(loginInfo: LoginInfo, passwordInfo: PasswordInfo): Future[PasswordInfo] = {
    store.get(loginInfo) match {
      case Some(_) =>
        save(loginInfo, passwordInfo)
      case None =>
        Future.failed(new Exception(s"cannot update $loginInfo, it does not exist"))
    }
  }

  override def add(loginInfo: LoginInfo, passwordInfo: PasswordInfo): Future[PasswordInfo] = {
    store.get(loginInfo) match {
      case None =>
        save(loginInfo, passwordInfo)
      case Some(_) =>
        Future.failed(new Exception(s"cannot add $loginInfo, it already exists"))
    }
  }

  override def remove(loginInfo: LoginInfo): Future[Unit] = {
    store -= loginInfo
    Future.successful(())
  }
}
