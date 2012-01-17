projectTemplate = require('templates/project')
DropdownRenderHelper = require('mixins/views/dropdown_render_helper').DropdownRenderHelper

class exports.ProjectView extends Backbone.View

  tagName:  "li"

  initialize: ->
    # We use bindAll when we're using a mixin that's called by jquery.
    _.bindAll(@)
    @bindTo(@model, 'change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = '#' + @model.url().substr(1)
    @$(@el).html(projectTemplate(project: json))
    @renderDropdown()
    @

# Add Mixins DropdownRenderHelper
exports.ProjectView.prototype = _.extend exports.ProjectView.prototype,
  DropdownRenderHelper
