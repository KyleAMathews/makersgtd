actionTemplate = require('templates/action')

class exports.ActionView extends Backbone.View

  tagName:  "li"

  events:
    'click .check'           : 'toggleDone'
    'dblclick .action-name' : 'edit'
    'click .action-destroy'    : 'destroy'
    'keypress .action-input'   : 'updateOnEnter'

  initialize: ->
    @model.bind('change', @render)
    @model.bind('change:cursorOn', @renderCursor)
    @model.bind('destroy', @remove)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = '#' + @model.url().substr(1)
    @$(@el).html(actionTemplate(action: json))
    # Bind event directly to input, cause older browsers doesn't
    # support this event on several types of elements.
    # Originally, this event was only applicable to form elements.
    @$('.action-input').bind 'blur', @update
    @

  renderCursor: =>
    if @model.get 'cursorOn'
      @$(@el).addClass 'cursor'
    else
      @$(@el).removeClass 'cursor'

  toggleDone: ->
    @model.toggle()

  edit: ->
    @$(@el).addClass "editing"
    @$('.action-input').focus()

  update: =>
    @model.save(name: @$('.action-input').val())
    @$(@el).removeClass "editing"

  updateOnEnter: (e) ->
    @update() if e.keyCode is $.ui.keyCode.ENTER

  destroy: =>
    @model.clear()
