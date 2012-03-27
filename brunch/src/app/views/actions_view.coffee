ActionView = require('views/action_view').ActionView
actionsTemplate = require('templates/actions')
Sortable = require('mixins/views/sortable').Sortable
AddNewModelView = require('views/add_new_model_view').AddNewModelView

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
    @$el.html actionsTemplate(
      options: @options
      length: @collection.notDone().length
    )
    # Return if there's no actions to render.
    if @collection.notDone().length is 0 then return @
    # Render each action.
    @addAll()
    # Add label if one is specified.
    if @options.addNewModelForm?
      @logChildView new AddNewModelView(
        el: @$('.add-new-action')
        type: 'action'
      ).render()

    # Make links fast.
    @$('a').fastButton(app.util.clickHandler)

    @

  addOne: (action) =>
    unless action.get 'done'
      @logChildView view = new ActionView model: action
      @$("ul#actions").append view.render().el

  addAll: =>
    @addOne action for action in @collection.notDone()
    @makeSortable('ul#actions')

  focusInput: (event) =>
    $('#new-action').focus()
    $('#new-action').val ""

# Add Mixins
exports.ActionsView.prototype = _.extend exports.ActionsView.prototype,
  Sortable
