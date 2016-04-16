EventEmitter = require('events').EventEmitter
assign = require 'object-assign'
jwt_decode = require 'jwt-decode'

AppDispatcher = require '../AppDispatcher.coffee'
Constants = require '../constants/Constants.coffee'

CHANGE_EVENT = '_change_event'
_loginInfo = {}

LoginInfoStore = assign({}, EventEmitter.prototype,
  getDisplayName: ->
    _loginInfo._displayName

  getJWT: ->
    _loginInfo._jwt

  emitChange: (dataKey) ->
    this.emit(CHANGE_EVENT)

  addChangeListener: (callback) ->
    this.on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    this.removeListener(CHANGE_EVENT, callback)
)

AppDispatcher.register( (action) ->
  switch action.actionType
    when Constants.LOGIN_USER
      _loginInfo =
        _jwt: action.jwt
        _displayName: action.displayName
      console.log()
      LoginInfoStore.emitChange(action.dataKey)
      break
    else
      # do nothing on other events
)

module.exports = LoginInfoStore
