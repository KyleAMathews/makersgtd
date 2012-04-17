ContextView = require('views/context_view').ContextView
contextsTemplate = require('templates/contexts')
AddNewModelView = require('views/add_new_model_view').AddNewModelView

class exports.ContextsView extends Backbone.View

  className: 'collection-view'
  id: 'contexts-view'

  initialize: ->
    @bindTo(@collection, 'add', @addOne)
    @bindTo(@collection, 'reset', @addAll)

  render: ->
    $(@el).html contextsTemplate()
    @addAll()
    @logChildView new AddNewModelView(
      el: @$('.add-new-context')
      type: 'context'
    ).render()
    @

  addOne: (context) =>
    @logChildView view = new ContextView model: context
    $("#contexts", @el).append view.render().el

  addAll: =>
    @$('#contexts').empty()
    app.collections.contexts.each @addOne
