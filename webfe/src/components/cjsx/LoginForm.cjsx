React = require 'react'

Button = require 'react-bootstrap/lib/Button'
Col = require 'react-bootstrap/lib/Col'
Grid = require 'react-bootstrap/lib/Grid'
Input = require 'react-bootstrap/lib/Input'
Row = require 'react-bootstrap/lib/Row'

AuthService = require '../../services/AuthService.coffee'

LoginForm = React.createClass(
  getInitialState: ->
    userName: ""
    password: ""

  _valid: ->
    if (!this.state.userName || !this.state.password)
      return false

    if (this.state.userName.length == 0 || this.state.password.length == 0)
      return false

    return true

  _handleChange: (changeEvent) ->
    if (changeEvent.target.id == "userName")
      this.setState({userName: changeEvent.target.value})
    else if (changeEvent.target.id == "password")
      this.setState({password: changeEvent.target.value})

  _handleSubmit: (submitEvent) ->
    submitEvent.preventDefault()
    AuthService.loginUser(this.state.userName, this.state.password)

  render: ->
    <Grid>
      <form>
        <Row>
          <Col xs={6} xsOffset={3}>
            <Input
              label="Username"
              id="userName"
              type="text"
              value={this.state.userName}
              onChange={this._handleChange}
            />
            <Input
              label="Password"
              id="password"
              type="password"
              value={this.state.password}
              onChange={this._handleChange}
            />
            <Button bsStyle="success" type="submit" disabled={!this._valid()} onClick={this._handleSubmit}>Login</Button>
          </Col>
        </Row>
      </form>
    </Grid>
)

module.exports = LoginForm
