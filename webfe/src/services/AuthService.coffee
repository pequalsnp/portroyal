request = require 'then-request'

AppDispatcher = require '../AppDispatcher.coffee'
Constants = require '../constants/Constants.coffee'
LoginAction = require '../actions/LoginAction.coffee'

AuthService =
  createUser: (userName, password, displayName) ->
    opts =
      headers: {"Accept": "application/json"}
    opts.json =
      userName: userName
      password: password
      displayName: displayName
    request('POST', "create_user", opts).done( (res) ->
      data = JSON.parse(res.body)
      LoginAction.loginUser(data.jwt, data.displayName)
    )

  loginUser: (userName, password) ->
    opts =
      headers: {"Accept": "application/json"}
    opts.json =
      userName: userName
      password: password
    request('POST', "login_user", opts).done( (res) ->
      data = JSON.parse(res.body)
      LoginAction.loginUser(data.jwt, data.displayName)
    )

  logout: ->
    LoginAction.logout()

module.exports = AuthService
