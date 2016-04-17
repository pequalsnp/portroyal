AppDispatcher = require '../AppDispatcher.coffee'
Constants = require '../constants/Constants.coffee'

LoginAction =
  loginUser: (jwt, displayName) ->
    AppDispatcher.dispatch(
      actionType: Constants.LOGIN_USER
      jwt: jwt
      displayName: displayName
    )

  logout: ->
    AppDispatcher.dispatch(
      actionType: Constants.LOGOUT_USER
    )

module.exports = LoginAction
