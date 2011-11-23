tagTemplate = require('templates/tag')

class exports.TagView extends Backbone.View

  tagName:  "li"

  events:
    'click .check'           : 'toggleDone'
    'dblclick .tag-name' : 'edit'
    'click .tag-destroy'    : 'destroy'
    'keypress .tag-input'   : 'updateOnEnter'

  initialize: ->
    @model.bind('change', @render)
    @model.bind('change:cursorOn', @renderCursor)
    @model.bind('destroy', @remove)
    @model.view = @

  render: =>
    @$(@el).html(tagTemplate(tag: @model.toJSON()))
    # Bind event directly to input, cause older browsers doesn't
    # support this event on several types of elements.
    # Originally, this event was only applicable to form elements.
    @$('.tag-input').bind 'blur', @update
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
    @$('.tag-input').focus()

  update: =>
    @model.save(name: @$('.tag-input').val())
    @$(@el).removeClass "editing"

  updateOnEnter: (e) ->
    @update() if e.keyCode is $.ui.keyCode.ENTER

  destroy: =>
    @model.clear()
