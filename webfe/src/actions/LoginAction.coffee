AppDispatcher = require '../AppDispatcher.coffee'
Constants = require '../constants/Constants.coffee'
bowserHistory = require('react-router').browserHistory

LoginAction =
  loginUser: (jwt, displayName) ->
    browserHistory.push("/")
    AppDispatcher.dispatch(
      actionType: Constants.LOGIN_USER
      jwt: jwt
      displayName: displayName
    )

module.exports = LoginAction
