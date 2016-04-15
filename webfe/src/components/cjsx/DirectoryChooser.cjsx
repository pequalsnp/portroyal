path = require 'path'
React = require 'React'

ListDirectoryAction = require '../../actions/ListDirectoryAction.coffee'
DirectoryContentsStore = require '../../stores/DirectoryContentsStore.coffee'

DirectoryChooserDirectory = require './DirectoryChooserDirectory.cjsx'

DirectoryChooser = React.createClass(
  propTypes:
    startDir: React.PropTypes.string
    dataKey: React.PropTypes.string

  getInitialState: ->
    currentDir: this.props.startDir
    contents: []

  componentWillMount: ->
    ListDirectoryAction.listDirectory(this.props.startDir, this.props.dataKey)

  componentDidMount: ->
    DirectoryContentsStore.addChangeListener(this.props.dataKey, this._onChange)

  componentWillUnmount: ->
    DirectoryContentsStore.removeChangeListener(this.props.dataKey, this._onChange)

  _onChange: ->
    directoryState = DirectoryContentsStore.get(this.props.dataKey)
    console.log(directoryState)
    this.setState(
      currentDir: directoryState.path
      contents: directoryState.items
    )

  render: ->
    console.log(this.state.currentDir)
    console.log(path.dirname(this.state.currentDir))
    doubleDot = <p key="..">
      <DirectoryChooserDirectory directoryName={".."} directoryPath={path.dirname(this.state.currentDir)} dataKey={this.props.dataKey} />
    </p>

    items = for item in this.state.contents
      if (item.isDirectory)
        <p key={item.name}>
          <DirectoryChooserDirectory directoryName={item.name} directoryPath={item.path} dataKey={this.props.dataKey} />
        </p>
    items.unshift(doubleDot)

    <div>
      <h1>{this.state.currentDir}</h1>
      {items}
    </div>
)

module.exports = DirectoryChooser
