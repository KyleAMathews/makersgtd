ModalView = require 'widgets/modal/modal_view'
AccountTemplate = require 'templates/account'

module.exports = class SettingsView extends Backbone.View

  initialize: ->
    $('html').on 'click.settings', 'form.account-edit button', (e) =>
      @save(e)

  onClose: ->
    $('html').off 'click.settings'

  render: ->
    $('.modal').remove()
    new ModalView(
      title: "Edit Account"
      body: AccountTemplate(
        name: @model.get('name')
        email: @model.get('email')
      )
    ).render()

  save: (e) ->
    e.preventDefault()
    name = $('.modal .name').val()
    console.log 'name', name
    email = $('.modal .email').val()
    password = $('.modal .password').val()
    password2 = $('.modal .password2').val()

    # Check that passwords are the same.
    unless password is "" and password2 is ""
      if password isnt password2
        $('.modal .error').html("<li>Passwords don't match</li>").show()
        $('.modal form').css('margin-top', 0)
        return

    newVals = {}
    newVals.name = name
    newVals.email = email
    unless password is ""
      newVals.password = password

    success = =>
      $('.modal').remove()
      $('.modal-backdrop').remove()

    @model.save(newVals, { success: success })
    $('.modal .loading').css('display', 'inline-block')
