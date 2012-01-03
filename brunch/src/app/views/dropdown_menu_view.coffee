DropdownMenuTemplate = require('templates/dropdown_menu')

class exports.DropdownMenuView extends Backbone.View

  initialize: ->
    @model.bind('change', @render)

  events:
    'click .command' : 'executeCommand'
    'click' : 'toggleActive'
    'mouseover .command' : 'markCommand'

  render: =>
    type = @options.model.get('type')
    @options.commands = {}
    if _.include ['action','project'], type
      @options.commands =
        'Complete' : app.util.toggleDonenessModel

      if @model.get('done')
        @options.commands['Not done'] = @options.commands['Complete']
        delete @options.commands['Complete']

    if _.include ['action','project','tag'], type
      @options.commands['Delete'] = app.util.deleteModel
      if @model.get('deleted')
        @options.commands['Undelete'] = app.util.undeleteModel
        delete @options.commands['Delete']

    $(@el).html(DropdownMenuTemplate( commands: @options.commands ))
    @

  executeCommand: (e) =>
    command = e.target.textContent
    @options.commands[command].call(@, @model)

  markCommand: (e) =>
    @$('li.active').removeClass('active')
    $(e.target).addClass('active')

  toggleActive: =>
    @$('.commands').toggle()
    $(@el).toggleClass('active')

  hide: =>
    @$('.commands').hide()
    $(@el).removeClass('active')

