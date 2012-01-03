actionTemplate = require('templates/action')
InjectModelMenu = require('mixins/views/inject_model_menu').InjectModelMenu
DropdownMenuView = require('views/dropdown_menu_view').DropdownMenuView

class exports.ActionView extends Backbone.View

  tagName:  "li"

  events:
    'click .check'           : 'injectModelMenu'

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
    new DropdownMenuView(
      el: @$('.dropdown')
      model: @model
      commands:
        'Complete' : app.util.completeModel
        'Delete' : app.util.deleteModel
    ).render()

    # Add hoverIntent.
    config =
      over: @showDropdown
      out: @hideDropdown
      timeout: 100
    $(@el).hoverIntent(config)
    @

  toggleDone: ->
    @model.toggle()

  # TODO move this code somehow to the dropdown_menu_view
  showDropdown: =>
    @$('.dropdown').addClass('over')

  hideDropdown: =>
    @$('.dropdown').removeClass('over active').find('.commands').hide()

# Add Mixins InjectModelMenu
exports.ActionView.prototype = _.extend exports.ActionView.prototype,
  InjectModelMenu
