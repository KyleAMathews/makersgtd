ActionView = require('views/action_view').ActionView
actionsTemplate = require('templates/actions')
Sortable = require('mixins/views/sortable').Sortable

class exports.ActionsView extends Backbone.View

  className: 'collection-view'
  id: 'actions-view'

  initialize: ->
    # We use bindAll when we're using a mixin that's called by jquery.
    _.bindAll(@)
    @bindTo @collection, 'add', @addOne
    @bindTo @collection, 'reset', @render
    @bindTo @collection, 'change:done', @render

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
    @makeSortable('ul#actions')

  focusInput: (event) =>
    $('#new-action').focus()
    $('#new-action').val ""

# Add Mixins
exports.ActionsView.prototype = _.extend exports.ActionsView.prototype,
  Sortable
