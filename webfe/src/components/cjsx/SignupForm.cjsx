React = require 'react'

Button = require 'react-bootstrap/lib/Button'
Col = require 'react-bootstrap/lib/Col'
Grid = require 'react-bootstrap/lib/Grid'
Input = require 'react-bootstrap/lib/Input'
Row = require 'react-bootstrap/lib/Row'

SignupForm = React.createClass(
  getInitialState: ->
    username: "Username"
    password: ""
    confirmPassword: ""

  _valid: ->
    if (!this.state.username || !this.state.password || !this.state.confirmPassword)
      return false

    if (this.state.username.length == 0 || this.state.password.length == 0 || this.state.confirmPassword.length == 0)
      return false

    if (this.state.password != this.state.confirmPassword)
      return false

    return true

  _handleChange: (changeEvent) ->
    if (changeEvent.target.id == "username")
      this.setState({username: changeEvent.target.value})
    else if (changeEvent.target.id == "password")
      this.setState({password: changeEvent.target.value})
    else if (changeEvent.target.id == "confirmpassword")
      this.setState({confirmPassword: changeEvent.target.value})

  _handleSubmit: (submitEvent) ->
    if (!this._valid())
      console.log("INVALID")
    submitEvent.preventDefault()

  render: ->
    <Grid>
      <form onSubmit={this._handleSubmit}>
        <Row>
          <Col xs={6} xsOffset={3}>
            <Input
              label="Username"
              id="username"
              type="text"
              value={this.state.username}
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
              id="confirmpassword"
              type="password"
              value={this.state.confirmpassword}
              onChange={this._handleChange}
            />
            <Button bsStyle="success" type="submit" disabled={!this._valid()}>Submit</Button>
          </Col>
        </Row>
      </form>
    </Grid>
)

module.exports = SignupForm
