tagTemplate = require('templates/tag_full')

class exports.TagFullView extends Backbone.View

  tagName:  "li"

  events:
    'dblclick .tag-name' : 'edit'
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

  edit: ->
    @$(@el).addClass "editing"
    @$('.tag-input').focus()

  update: =>
    @model.save(name: @$('.tag-input').val())
    @$(@el).removeClass "editing"

  updateOnEnter: (e) ->
    @update() if e.keyCode is $.ui.keyCode.ENTER
