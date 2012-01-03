actionTemplate = require('templates/action')
DropdownMenuView = require('views/dropdown_menu_view').DropdownMenuView
DropdownRenderHelper = require('mixins/views/dropdown_render_helper').DropdownRenderHelper

class exports.ActionView extends Backbone.View

  tagName:  "li"

  initialize: ->
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

  showDropdown: =>
    @$('.dropdown').addClass('over')

  hideDropdown: =>
    @$('.dropdown').removeClass('over')
    @dropdownMenu.hide()

# Add Mixins DropdownRenderHelper
exports.ActionView.prototype = _.extend exports.ActionView.prototype,
  DropdownRenderHelper
