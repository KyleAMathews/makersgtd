projectTemplate = require('templates/project')

class exports.ProjectView extends Backbone.View

  tagName:  "li"

  events:
    'click .check'           : 'injectModelMenu'

  initialize: ->
    @model.bind('change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = '#' + @model.url().substr(1)
    @$(@el).html(projectTemplate(project: json))
    @

  injectModelMenu: (e) =>
    if e.currentTarget.checked
      app.models.contextMenu.add(@model)
    else
      app.models.contextMenu.remove(@model)
