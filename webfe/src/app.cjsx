React = require 'React'
ReactDOM = require 'react-dom'

DirectoryChooser = require './components/cjsx/DirectoryChooser.cjsx'
SignupForm = require './components/cjsx/SignupForm.cjsx'

render = ->
  ReactDOM.render(
    <SignupForm />,
    document.getElementById("app")
  )

render()
