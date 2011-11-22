ActionView = require('views/action_view').ActionView
actionsTemplate = require('templates/actions')

class exports.ActionsView extends Backbone.View

  id: 'actions-view'

  initialize: ->
    app.collections.actions.bind 'add', @addOne
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
    $("#actions", @el).append view.render().el

  addAll: =>
    @addOne action for action in app.collections.actions.notDone()
    app.collections.actions.initCursor()
    @$('ul').sortable(
      start: (event, ui) ->
        $(event.target).css('cursor', 'move')
      stop: (event, ui) ->
        $(event.target).css('cursor', 'default')
    )
    @$('ul').bind('sortupdate', @resetOrder)

  changeDoneState: (action) =>
    unless action.get('done')
      @render().addAll()
    else
      @render().addAll()

  resetOrder: =>
    @$('li div.action').each (index) ->
      id = $(@).data('id')
      # Save new order to action models but only to those which were changed.
      unless app.collections.actions.get(id).get('order') is index
        app.collections.actions.get(id).set( order: index ).save()

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
