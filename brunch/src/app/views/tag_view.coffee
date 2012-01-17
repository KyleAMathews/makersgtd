tagTemplate = require('templates/tag')
DropdownRenderHelper = require('mixins/views/dropdown_render_helper').DropdownRenderHelper

class exports.TagView extends Backbone.View

  tagName:  "li"

  initialize: ->
    # We use bindAll when we're using a mixin that's called by jquery.
    _.bindAll(@)
    @bindTo(@model, 'change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = '#' + @model.url().substr(1)
    @$(@el).html(tagTemplate(tag: json))
    @renderDropdown()
    @

# Add Mixins DropdownRenderHelper
exports.TagView.prototype = _.extend exports.TagView.prototype,
  DropdownRenderHelper
