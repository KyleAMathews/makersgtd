ActionView = require('views/action_view').ActionView
actionsTemplate = require('templates/actions')

class exports.DoneActionsView extends Backbone.View

  id: 'done-actions-view'

  initialize: ->
    app.collections.actions.bind 'reset', @addAll
    app.collections.actions.bind 'change:done', @changeDoneState
    $(document).bind 'keydown', 'j', @cursorDown
    $(document).bind 'keydown', 'k', @cursorUp
    $(document).bind 'keydown', 'x', @checkAtCursor
    $(document).bind 'keyup', 'a', @focusInput
    $(document).bind 'keydown', 'o', @openAtCursor

  render: ->
    $(@el).html actionsTemplate()
    @

  addOne: (action) =>
    view = new ActionView model: action
    $(@el).find("#actions").append view.render().el

  addAll: =>
    @addOne action for action in app.collections.actions.done()
    app.collections.actions.initCursor()

  changeDoneState: (action) =>
    if action.get('done')
      console.log "DONE: I'm adding a new done action"
      @addOne action
    else
      console.log "DONE: I'm removing a action because it is now /not/ done."
      # $(action.view.el, @el).remove()
      # console.log action.view.el
      @render().addAll()

  cursorDown: ->
    app.collections.actions.cursorDown()

  cursorUp: ->
    app.collections.actions.cursorUp()

  checkAtCursor: ->
    app.collections.actions.checkAtCursor()

  focusInput: (event) =>
    $('#new-action').focus()
    $('#new-action').val ""

  openAtCursor: ->
    app.collections.actions.openAtCursor()
