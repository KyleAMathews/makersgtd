actionTemplate = require('templates/action')
DropdownMenuView = require('views/dropdown_menu_view').DropdownMenuView
DropdownRenderHelper = require('mixins/views/dropdown_render_helper').DropdownRenderHelper

class exports.ActionView extends Backbone.View

  tagName:  "li"

  initialize: ->
    # We use bindAll when we're using a mixin that's called by jquery.
    _.bindAll(@)
    @model.bind('change', @render)
    @model.bind('destroy', @remove)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = @model.iurl()
    @$(@el).html(actionTemplate(
      action: json
    ))
    @renderDropdown()
    @

  toggleDone: ->
    @model.toggle()

# Add Mixins DropdownRenderHelper
exports.ActionView.prototype = _.extend exports.ActionView.prototype,
  DropdownRenderHelper
