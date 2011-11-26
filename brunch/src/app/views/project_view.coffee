projectTemplate = require('templates/project')

class exports.ProjectView extends Backbone.View

  tagName:  "li"

  events:
    'dblclick .project-name' : 'edit'
    'keypress .project-input'   : 'updateOnEnter'

  initialize: ->
    @model.bind('change', @render)
    @model.bind('change:cursorOn', @renderCursor)
    @model.bind('destroy', @remove)
    @model.view = @

  render: =>
    @$(@el).html(projectTemplate(project: @model.toJSON()))
    # Bind event directly to input, cause older browsers doesn't
    # support this event on several types of elements.
    # Originally, this event was only applicable to form elements.
    @$('.project-input').bind 'blur', @update
    @

  renderCursor: =>
    if @model.get 'cursorOn'
      @$(@el).addClass 'cursor'
    else
      @$(@el).removeClass 'cursor'

  edit: ->
    @$(@el).addClass "editing"
    @$('.project-input').focus()

  update: =>
    @model.save(name: @$('.project-input').val())
    @$(@el).removeClass "editing"

  updateOnEnter: (e) ->
    @update() if e.keyCode is $.ui.keyCode.ENTER
