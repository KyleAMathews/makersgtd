editableTemplate = require('templates/editable')
ExpandingAreaView = require('views/expanding_area_view').ExpandingAreaView

class exports.EditableView extends Backbone.View

  className: 'editable'

  events:
    'keypress .save-on-enter .input'   : 'updateOnEnter'
    'click .editable .display' : 'edit'
    'click .edit .save' : 'update'
    'click .edit .cancel' : 'stopEditing'
    'click .blank-slate' : 'edit'

  initialize: ->
    @model.bind('change:' + @options.field, @render)

  render: =>
    context = {}
    # Options get added as classes to the widget.
    context.classes = ""
    if @options.options?
      for option in @options.options
        context.classes += option + " "

    # Add all other settings.
    for k,v of @options
      context[k] = v

    # Render with markdown if necessary.
    if @options.html and @model.get(@options.field)?
      context.display_text = @model.getHtml(@options.field)
    else
      context.display_text = @model.get(@options.field)

    context.edit_text = @model.get(@options.field)

    $(@el).html(editableTemplate(context))
    new ExpandingAreaView(
      el: @$('.expanding-area')
      edit_text: @model.get(@options.field)
    ).render()
    @


  edit: =>
    @$(@el).addClass "editing"
    @$('.input').focus()

  stopEditing: =>
    @$(@el).removeClass "editing"

  update: =>
    field = {}
    field[@options.field] = @$('.input').val()

    @model.save(
      field
    )
    @stopEditing()

  updateOnEnter: (e) ->
    @update() if e.keyCode is $.ui.keyCode.ENTER
