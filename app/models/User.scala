package models

import com.mohiva.play.silhouette.api.{Identity, LoginInfo}

case class User(
  id: String,
  loginInfo: LoginInfo,
  displayName: String,
  userName: String
) extends Identity
