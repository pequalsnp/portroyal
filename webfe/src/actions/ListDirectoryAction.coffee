request = require 'then-request'
_ = require 'lodash'

AppDispatcher = require '../AppDispatcher.coffee'
Constants = require '../constants/Constants.coffee'

opts =
  headers: {"Accept": "application/json"}

ListDirectoryAction =
  listDirectory: _.debounce( (directory, dataKey) ->
    opts.qs =
      directory: directory
    request('GET', "list_directory", opts).done( (res) ->
      data = JSON.parse(res.body)
      AppDispatcher.dispatch({
        actionType: Constants.LIST_DIRECTORY_NEW_DATA
        directoryState: data
        dataKey: dataKey
      })
    )
  , 200)

module.exports = ListDirectoryAction
