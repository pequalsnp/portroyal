EventEmitter = require('events').EventEmitter
assign = require 'object-assign'
jwt_decode = require 'jwt-decode'
browserHistory = require('react-router').browserHistory

AppDispatcher = require '../AppDispatcher.coffee'
Constants = require '../constants/Constants.coffee'

CHANGE_EVENT = '_change_event'
_displayName = undefined
_jwt = undefined

LoginInfoStore = assign({}, EventEmitter.prototype,
  getDisplayName: ->
    _displayName

  getJWT: ->
    _jwt

  isLoggedIn: ->
    return !!_jwt

  emitChange: ->
    this.emit(CHANGE_EVENT)

  addChangeListener: (callback) ->
    this.on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    this.removeListener(CHANGE_EVENT, callback)
)

AppDispatcher.register( (action) ->
  switch action.actionType
    when Constants.LOGIN_USER
      _jwt = action.jwt
      _displayName = action.displayName
      LoginInfoStore.emitChange()
      browserHistory.push("/")
      break
    when Constants.LOGOUT_USER
      _jwt = undefined
      _displayName = undefined
      LoginInfoStore.emitChange()
      browserHistory.push("/login")
      break
    else
      # do nothing on other events
)

module.exports = LoginInfoStore
