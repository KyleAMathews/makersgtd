SubCollection = require('collections/sub_collection').SubCollection
projectTemplate = require('templates/project')
ActionsView = require('views/actions_view').ActionsView

class exports.ProjectView extends Backbone.View

  className: 'project-list-item'
  tagName: 'li'

  initialize: ->
    # We use bindAll when we're using a mixin that's called by jquery.
    _.bindAll(@)
    @bindTo(@model, 'change', @render)
    @bindTo(@model, 'destroy', @remove)
    @bindTo(@model, 'remove', @remove)
    @bindTo(@model, 'change:action_links', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = @model.iurl()
    json.undone = @model.notDoneActions().length
    @$el.html(projectTemplate(project: json))

    # Humanize dates
    @$('span.date').timeago()

    # Make links fast.
    @$('a').fastClick(app.util.clickHandler)
    @
