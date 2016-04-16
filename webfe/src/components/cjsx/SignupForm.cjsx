React = require 'react'

Button = require 'react-bootstrap/lib/Button'
Col = require 'react-bootstrap/lib/Col'
Grid = require 'react-bootstrap/lib/Grid'
Input = require 'react-bootstrap/lib/Input'
Row = require 'react-bootstrap/lib/Row'

AuthService = require '../../services/AuthService.coffee'

SignupForm = React.createClass(
  getInitialState: ->
    userName: ""
    displayName: ""
    password: ""
    confirmPassword: ""

  _valid: ->
    if (!this.state.displayName || !this.state.userName || !this.state.password || !this.state.confirmPassword)
      return false

    if (this.state.displayName.length == 0 || this.state.userName.length == 0 || this.state.password.length == 0 || this.state.confirmPassword.length == 0)
      return false

    if (this.state.password != this.state.confirmPassword)
      return false

    return true

  _handleChange: (changeEvent) ->
    if (changeEvent.target.id == "userName")
      this.setState({userName: changeEvent.target.value})
    else if (changeEvent.target.id == "displayName")
      this.setState({displayName: changeEvent.target.value})
    else if (changeEvent.target.id == "password")
      this.setState({password: changeEvent.target.value})
    else if (changeEvent.target.id == "confirmPassword")
      this.setState({confirmPassword: changeEvent.target.value})

  _handleSubmit: (submitEvent) ->
    submitEvent.preventDefault()
    AuthService.createUser(this.state.userName, this.state.password, this.state.displayName)

  render: ->
    <Grid>
      <form>
        <Row>
          <Col xs={6} xsOffset={3}>
            <Input
              label="Display Name"
              id="displayName"
              type="text"
              value={this.state.displayName}
              onChange={this._handleChange}
            />
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
            <Input
              label="Confirm Password"
              id="confirmPassword"
              type="password"
              value={this.state.confirmPassword}
              onChange={this._handleChange}
            />
            <Button bsStyle="success" type="submit" disabled={!this._valid()} onClick={this._handleSubmit}>Submit</Button>
          </Col>
        </Row>
      </form>
    </Grid>
)

module.exports = SignupForm
