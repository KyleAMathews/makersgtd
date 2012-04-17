contextTemplate = require('templates/context')
SubCollection = require('collections/sub_collection').SubCollection
pv = require('views/projects_view')
ActionsView = require('views/actions_view').ActionsView

class exports.ContextView extends Backbone.View

  className: 'context-list-item'

  initialize: ->
    # We use bindAll when we're using a mixin that's called by jquery.
    _.bindAll(@)
    @bindTo(@model, 'change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = @model.iurl()
    @$el.html(contextTemplate(context: json))

    # Make links fast.
    @$('a').fastButton(app.util.clickHandler)

    @
