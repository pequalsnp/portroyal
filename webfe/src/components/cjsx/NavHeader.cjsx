React = require 'React'
IndexLink = require('react-router').IndexLink
Link = require('react-router').Link
Nav = require 'react-bootstrap/lib/Nav'
NavItem = require 'react-bootstrap/lib/NavItem'
Navbar = require 'react-bootstrap/lib/Navbar'
LinkContainer = require 'react-router-bootstrap/lib/LinkContainer'

NavHeader = React.createClass(
  render: ->
    <div>
      <Navbar>
        <Navbar.Header>
          <Navbar.Brand>
          <IndexLink to="/">Port Royal</IndexLink>
          </Navbar.Brand>
        </Navbar.Header>
        <Nav>
          <LinkContainer to={{pathname: '/login'}} activeStyle={{active: true}}><NavItem>Login</NavItem></LinkContainer>
        </Nav>
      </Navbar>

      {this.props.children}
    </div>
)

module.exports = NavHeader
