React = require 'React'
ReactDOM = require 'react-dom'
Router = require('react-router').Router
Route = require('react-router').Route
IndexRoute = require('react-router').IndexRoute
browserHistory = require('react-router').browserHistory

DirectoryChooser = require './components/cjsx/DirectoryChooser.cjsx'
SignupForm = require './components/cjsx/SignupForm.cjsx'
LoginForm = require './components/cjsx/LoginForm.cjsx'
NavHeader = require './components/cjsx/NavHeader.cjsx'
Home = require './components/cjsx/Home.cjsx'


render = ->
  ReactDOM.render(
    <Router history={browserHistory}>
      <Route path="/" component={NavHeader}>
        <IndexRoute component={Home}/>
        <Route path="/login" component={LoginForm} />
        <Route path="/signup" component={SignupForm} />
      </Route>
    </Router>,
    document.getElementById("app")
  )

render()
