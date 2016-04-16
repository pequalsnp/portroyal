React = require 'react'

ListDirectoryAction = require '../../actions/ListDirectoryAction.coffee'
DirectoryContentsStore = require '../../stores/DirectoryContentsStore.coffee'

DirectoryChooserDirectory = React.createClass(
  propTypes:
    directoryName: React.PropTypes.string
    dataKey: React.PropTypes.string

  _onClick: ->
    ListDirectoryAction.listDirectory(this.props.directoryPath, this.props.dataKey)

  render: ->
    <button onClick={this._onClick}>{this.props.directoryName}</button>
)

module.exports = DirectoryChooserDirectory
