projectTemplate = require('templates/project')
InjectModelMenu = require('mixins/views/inject_model_menu').InjectModelMenu

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

# Add Mixins InjectModelMenu
exports.ProjectView.prototype = _.extend exports.ProjectView.prototype,
  InjectModelMenu
