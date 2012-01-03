DropdownMenuTemplate = require('templates/dropdown_menu')

class exports.DropdownMenuView extends Backbone.View

  events:
    'click .command' : 'executeCommand'
    'click' : 'toggleDropdown'
    'mouseover .command' : 'markCommand'

  render: =>
    $(@el).html(DropdownMenuTemplate( commands: @options.commands ))
    @

  executeCommand: (e) =>
    command = e.target.textContent
    @options.commands[command].call(@, @model)

  markCommand: (e) =>
    @$('li.active').removeClass('active')
    $(e.target).addClass('active')

  toggleDropdown: =>
    @$('.commands').toggle()
    $(@el).toggleClass('active')
