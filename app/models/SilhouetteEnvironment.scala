package models

import com.mohiva.play.silhouette.api.Env
import com.mohiva.play.silhouette.impl.authenticators.JWTAuthenticator

/**
  * Created by kyles on 4/15/2016.
  */
trait SilhouetteEnvironment extends Env {
  type I = User
  type A = JWTAuthenticator
}
