request = require 'then-request'
_ = require 'lodash'

AppDispatcher = require '../AppDispatcher.coffee'
Constants = require '../constants/Constants.coffee'

TypeaheadActions =
  fetch:
    _.debounce( (url, query, dataKey) ->
      opts = {
        headers:
          Accept: "application/json"
        qs: query
      }
      request('GET', url, opts).done( (res) ->
        console.log(res)
        data = JSON.parse(res.body)
        AppDispatcher.dispatch(
          actionType: Constants.TYPEAHEAD_NEW_DATA
          dataKey: dataKey
          newData: data.results
        )
      )
    )

module.exports = TypeaheadActions
