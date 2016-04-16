package models.forms

import play.api.data.Form
import play.api.data.Forms._

object LoginUserForm {
  val form = Form(
    mapping(
      "userName" -> nonEmptyText,
      "password" -> nonEmptyText
    )(Data.apply)(Data.unapply)
  )

  case class Data(
    userName: String,
    password: String
  )
}
