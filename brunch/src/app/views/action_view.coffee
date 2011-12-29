actionTemplate = require('templates/action')
InjectModelMenu = require('mixins/views/inject_model_menu').InjectModelMenu
ExpandCommandsView = require('views/expand_commands_view').ExpandCommandsView

class exports.ActionView extends Backbone.View

  tagName:  "li"

  events:
    'click .check'           : 'injectModelMenu'
    'mouseenter' : 'showCommands'
    'mouseleave' : 'hideCommands'

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
    new ExpandCommandsView(
      el: @$('.commands')
      model: @model
      commands:
        'Complete' : app.util.completeModel
        'Delete' : app.util.deleteModel
    ).render()
    @

  toggleDone: ->
    @model.toggle()

  showCommands: (e) =>
    @$('.commands').slideDown('fast')

  hideCommands: (e) =>
    @$('.commands').slideUp('fast')

# Add Mixins InjectModelMenu
exports.ActionView.prototype = _.extend exports.ActionView.prototype,
  InjectModelMenu
