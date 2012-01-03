tagTemplate = require('templates/tag')
DropdownRenderHelper = require('mixins/views/dropdown_render_helper').DropdownRenderHelper

class exports.TagView extends Backbone.View

  tagName:  "li"

  initialize: ->
    @model.bind('change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = '#' + @model.url().substr(1)
    @$(@el).html(tagTemplate(tag: json))
    @renderDropdown()
    @

  showDropdown: =>
    @$('.dropdown').addClass('over')

  hideDropdown: =>
    @$('.dropdown').removeClass('over')
    @dropdownMenu.hide()

# Add Mixins DropdownRenderHelper
exports.TagView.prototype = _.extend exports.TagView.prototype,
  DropdownRenderHelper
