React = require 'React'
ReactDOM = require 'react-dom'

DirectoryChooser = require './components/cjsx/DirectoryChooser.cjsx'

render = ->
  ReactDOM.render(
    <DirectoryChooser startDir={"/"} dataKey={"testDirChooser"}/>,
    document.getElementById("app")
  )

render()
