EventEmitter = require('events').EventEmitter
assign = require 'object-assign'

AppDispatcher = require '../AppDispatcher.coffee'
Constants = require '../constants/Constants.coffee'

CHANGE_EVENT = '_change_event'

_directoryContents = {}
update = (dataKey, newData) ->
  _directoryContents[dataKey] = newData

DirectoryContentsStore = assign({}, EventEmitter.prototype,
  get: (dataKey) ->
    _directoryContents[dataKey]

  emitChange: (dataKey) ->
    this.emit(dataKey + CHANGE_EVENT)

  addChangeListener: (dataKey, callback) ->
    this.on(dataKey + CHANGE_EVENT, callback)

  removeChangeListener: (dataKey, callback) ->
    this.removeListener(dataKey + CHANGE_EVENT, callback)
)

AppDispatcher.register( (action) ->
  switch action.actionType
    when Constants.LIST_DIRECTORY_NEW_DATA
      update(action.dataKey, action.directoryState)
      DirectoryContentsStore.emitChange(action.dataKey)
      break
    else
      # do nothing on other events
)

module.exports = DirectoryContentsStore
