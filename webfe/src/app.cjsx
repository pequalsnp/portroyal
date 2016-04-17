React = require 'React'
ReactDOM = require 'react-dom'
Router = require('react-router').Router
Route = require('react-router').Route
IndexRoute = require('react-router').IndexRoute
browserHistory = require('react-router').browserHistory

LoginInfoStore = require './stores/LoginInfoStore.coffee'

DirectoryChooser = require './components/cjsx/DirectoryChooser.cjsx'
SignupForm = require './components/cjsx/SignupForm.cjsx'
LoginForm = require './components/cjsx/LoginForm.cjsx'
NavHeader = require './components/cjsx/NavHeader.cjsx'
Home = require './components/cjsx/Home.cjsx'
TypeaheadSearchBox = require './components/cjsx/TypeaheadSearchBox.cjsx'

TypeaheadSearchBoxWrapper = React.createClass(
  render: ->
    <TypeaheadSearchBox dataKey="showSearchTypeahead" url="/tv_show_search" queryParam="query" />
)

requireAuth = (nextState, replace) ->
  if !LoginInfoStore.isLoggedIn()
    replace('/login')

render = ->
  ReactDOM.render(
    <Router history={browserHistory}>
      <Route path="/" component={NavHeader} onEnter={requireAuth}>
        <IndexRoute component={Home}/>
        <Route path="/add_tv_show" component={TypeaheadSearchBoxWrapper} />
      </Route>
      <Route path="/login" component={LoginForm} />
      <Route path="/signup" component={SignupForm} />
    </Router>,
    document.getElementById("app")
  )

render()
