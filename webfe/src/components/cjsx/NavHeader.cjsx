React = require 'React'
IndexLink = require('react-router').IndexLink
Link = require('react-router').Link
MenuItem = require 'react-bootstrap/lib/MenuItem'
Nav = require 'react-bootstrap/lib/Nav'
NavItem = require 'react-bootstrap/lib/NavItem'
NavDropdown = require 'react-bootstrap/lib/NavDropdown'
Navbar = require 'react-bootstrap/lib/Navbar'
LinkContainer = require 'react-router-bootstrap/lib/LinkContainer'

LoginInfoStore = require '../../stores/LoginInfoStore.coffee'
AuthService = require '../../services/AuthService.coffee'

NavHeader = React.createClass(
  getInitialState: ->
    loggedInUserDisplayName: LoginInfoStore.getDisplayName()

  componentDidMount: ->
    LoginInfoStore.addChangeListener(this._onLoginChange)

  componentWillUnmount: ->
    LoginInfoStore.removeChangeListener(this._onLoginChange)

  _onLoginChange: ->
    this.setState({loggedInUserDisplayName: LoginInfoStore.getDisplayName()})

  render: ->
    <div>
      <Navbar>
        <Navbar.Header>
          <Navbar.Brand>
          <IndexLink to="/">Port Royal</IndexLink>
          </Navbar.Brand>
        </Navbar.Header>
        <Nav>
          <LinkContainer to='/login' activeStyle={{active: true}}><NavItem>Login</NavItem></LinkContainer>
          <LinkContainer to='/signup' activeStyle={{active: true}}><NavItem>SignUp</NavItem></LinkContainer>
        </Nav>
          {
            if (this.state.loggedInUserDisplayName && this.state.loggedInUserDisplayName.length > 0)
              <Nav pullRight>
                <NavDropdown eventKey={3} title={LoginInfoStore.getDisplayName()} id="user-dropdown">
                  <MenuItem onClick={AuthService.logout}>Logout</MenuItem>
                </NavDropdown>
              </Nav>
          }
      </Navbar>

      {this.props.children}
    </div>
)

module.exports = NavHeader
