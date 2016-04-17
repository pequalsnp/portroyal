React = require 'react'

Input = require 'react-bootstrap/lib/Input'

TypeaheadStore = require '../../stores/TypeaheadStore.coffee'
TypeaheadActions = require '../../actions/TypeaheadActions.coffee'

TypeaheadSearchBox = React.createClass(
  propTypes:
    dataKey: React.PropTypes.string.isRequired
    url: React.PropTypes.string.isRequired
    queryParam: React.PropTypes.string.isRequired

  getInitialState: ->
    itemData: []

  componentDidMount: ->
    TypeaheadStore.addChangeListener(this.props.dataKey, this._onNewData)

  componentWillUnmount: ->
    TypeaheadStore.removeChangeListener(this.props.dataKey, this._onNewData)

  _onNewData: ->
    this.setState({itemData: TypeaheadStore.get(this.props.dataKey)})

  _onKeyUp: (event) ->
    query = {}
    query[this.props.queryParam] = event.target.value
    TypeaheadActions.fetch(this.props.url, query, this.props.dataKey)

  render: ->
    <div>
      <Input
        label="Username"
        id="userName"
        type="text"
        onKeyUp={this._onKeyUp}
      />
      {
        for item in this.state.itemData
          <div>{item.title}</div>
      }
    </div>
)

module.exports = TypeaheadSearchBox
