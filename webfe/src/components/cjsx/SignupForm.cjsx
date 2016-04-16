React = require 'react'

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
    <form onSubmit={this._handleSubmit}>
      <input
        id="username"
        type="text"
        value={this.state.username}
        onChange={this._handleChange}
      />
      <input
        id="password"
        type="password"
        value={this.state.password}
        onChange={this._handleChange}
      />
      <input
        id="confirmpassword"
        type="password"
        value={this.state.confirmpassword}
        onChange={this._handleChange}
      />
      <button type="submit" disabled={!this._valid()}>Submit</button>
    </form>
)

module.exports = SignupForm
