projectTemplate = require('templates/project')
DropdownRenderHelper = require('mixins/views/dropdown_render_helper').DropdownRenderHelper

class exports.ProjectView extends Backbone.View

  tagName:  "li"

  initialize: ->
    @model.bind('change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = '#' + @model.url().substr(1)
    @$(@el).html(projectTemplate(project: json))
    @renderDropdown()
    @

  showDropdown: =>
    @$('.dropdown').addClass('over')

  hideDropdown: =>
    @$('.dropdown').removeClass('over')
    @dropdownMenu.hide()

# Add Mixins DropdownRenderHelper
exports.ProjectView.prototype = _.extend exports.ProjectView.prototype,
  DropdownRenderHelper
