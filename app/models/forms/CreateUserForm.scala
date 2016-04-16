package models.forms

import play.api.data.Form
import play.api.data.Forms._

object CreateUserForm {
  val form = Form(
    mapping(
      "displayName" -> nonEmptyText,
      "userName" -> nonEmptyText,
      "password" -> nonEmptyText
    )(Data.apply)(Data.unapply)
  )

  case class Data(
    displayName: String,
    userName: String,
    password: String
  )
}
