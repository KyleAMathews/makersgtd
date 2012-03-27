tagTemplate = require('templates/tag')
SubCollection = require('collections/sub_collection').SubCollection
pv = require('views/projects_view')
ActionsView = require('views/actions_view').ActionsView

class exports.TagView extends Backbone.View

  className: 'tag-list-item'

  initialize: ->
    # We use bindAll when we're using a mixin that's called by jquery.
    _.bindAll(@)
    @bindTo(@model, 'change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = @model.iurl()
    @$el.html(tagTemplate(tag: json))

    # Make links fast.
    @$('a').fastButton(app.util.clickHandler)

    @
