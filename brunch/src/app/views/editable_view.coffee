editableTemplate = require('templates/editable')

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
    model = {}
    # Options get added as classes to the widget.
    model.classes = ""
    if @options.options?
      for option in @options.options
        model.classes += option + " "

    # Add all other settings.
    for k,v of @options
      model[k] = v

    # Render with markdown if necessary.
    if @options.html and @model.get(@options.field)?
      model.display_text = markdown.makeHtml(@model.get(@options.field))
    else
      model.display_text = @model.get(@options.field)

    model.edit_text = @model.get(@options.field)

    $(@el).html(editableTemplate(model))

    # Make sure HTML is inserted first.
    callback = -> @$('.expanding-area').makeExpandingArea()
    setTimeout callback, 0
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
