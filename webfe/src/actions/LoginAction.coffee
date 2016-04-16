AppDispatcher = require '../AppDispatcher.coffee'
Constants = require '../constants/Constants.coffee'
browserHistory = require('react-router').browserHistory

LoginAction =
  loginUser: (jwt, displayName) ->
    browserHistory.push("/")
    AppDispatcher.dispatch(
      actionType: Constants.LOGIN_USER
      jwt: jwt
      displayName: displayName
    )

  logout: ->
    AppDispatcher.dispatch(
      actionType: Constants.LOGOUT_USER
    )
    browserHistory.push("/login")

module.exports = LoginAction
