ActionView = require('views/action_view').ActionView
actionsTemplate = require('templates/actions')

class exports.ActionsView extends Backbone.View

  className: 'collection-view'
  id: 'actions-view'

  initialize: ->
    @collection.bind 'add', @addOne
    @collection.bind 'reset', @render
    @collection.bind 'change:done', @render

  render: =>
    $(@el).html actionsTemplate()
    # Return if there's no actions to render.
    if @collection.notDone().length is 0 then return @
    # Render each action.
    @addAll()
    # Add label if one is specified.
    if @options.label?
      $(@el).prepend('<h4>' + @options.label + '</h4>')
    # Remove the last border.
    @$('li:last').css('border-color', 'rgba(0,0,0,0)')
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

  resetOrder: =>
    @$('li div.action').each (index) ->
      id = $(@).data('id')
      # Save new order to action models but only to those which were changed.
      unless @collection.get(id).get('order') is index
        @collection.get(id).set( order: index ).save()

  focusInput: (event) =>
    $('#new-action').focus()
    $('#new-action').val ""
