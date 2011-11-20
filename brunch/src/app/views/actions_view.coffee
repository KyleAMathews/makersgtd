ActionView = require('views/action_view').ActionView
actionsTemplate = require('templates/actions')

class exports.ActionsView extends Backbone.View

  id: 'actions-view'

  initialize: ->
    app.collections.actions.bind 'add', @addOne
    app.collections.actions.bind 'reset', @addAll
    $(document).bind 'keydown', 'j', @cursorDown
    $(document).bind 'keydown', 'k', @cursorUp
    $(document).bind 'keydown', 'x', @checkAtCursor
    $(document).bind 'keyup', 'a', @focusInput

  render: ->
    $(@el).html actionsTemplate()
    @

  addOne: (action) =>
    view = new ActionView model: action
    $(@el).find("#actions").append view.render().el

  addAll: =>
    app.collections.actions.each @addOne
    app.collections.actions.initCursor()

  cursorDown: ->
    app.collections.actions.cursorDown()

  cursorUp: ->
    app.collections.actions.cursorUp()

  checkAtCursor: ->
    app.collections.actions.checkAtCursor()

  focusInput: (event) =>
    $('#new-action').focus()
    $('#new-action').val ""
