EventEmitter = require('events').EventEmitter
assign = require 'object-assign'

AppDispatcher = require '../AppDispatcher.coffee'
Constants = require '../constants/Constants.coffee'

CHANGE_EVENT = '_change_event'
_typeaheadResults = {}

TypeaheadStore = assign({}, EventEmitter.prototype,
  get: (dataKey) ->
    _typeaheadResults[dataKey]

  emitChange: (dataKey) ->
    this.emit(dataKey + CHANGE_EVENT)

  addChangeListener: (dataKey, callback) ->
    this.on(dataKey + CHANGE_EVENT, callback)

  removeChangeListener: (dataKey, callback) ->
    this.removeListener(dataKey + CHANGE_EVENT, callback)
)

AppDispatcher.register( (action) ->
  switch action.actionType
    when Constants.TYPEAHEAD_NEW_DATA
      _typeaheadResults[action.dataKey] = action.newData
      TypeaheadStore.emitChange(action.dataKey)
      break
    else
      #ignore other events
)

module.exports = TypeaheadStore
