ActionView = require('views/action_view').ActionView
actionsTemplate = require('templates/actions')

class exports.ActionsView extends Backbone.View

  className: 'collection-view'
  id: 'actions-view'

  initialize: ->
    @collection.bind 'add', @addOne
    @collection.bind 'reset', @addAll
    @collection.bind 'change:done', @changeDoneState

  render: ->
    $(@el).html actionsTemplate()
    @addAll()
    @

  addOne: (action) =>
    view = new ActionView model: action
    $("ul#actions", @el).append view.render().el

  addAll: =>
    @addOne action for action in @collection.notDone()
    @$('ul').sortable(
      start: (event, ui) ->
        $(event.target).parent().addClass('sorting')
      stop: (event, ui) ->
        $(event.target).parent().removeClass('sorting')
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
      unless @collection.get(id).get('order') is index
        @collection.get(id).set( order: index ).save()

  focusInput: (event) =>
    $('#new-action').focus()
    $('#new-action').val ""
