ExpandCommandsTemplate = require('templates/expand_commands')

class exports.ExpandCommandsView extends Backbone.View

  events:
    'click' : 'executeCommand'

  render: =>
    $(@el).html(ExpandCommandsTemplate( commands: @options.commands ))
    @

  executeCommand: (e) =>
    command = e.target.textContent
    @options.commands[command].call(@, @model)
