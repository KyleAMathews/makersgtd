linkerTemplate = require('templates/linker')

class exports.LinkerView extends Backbone.View

  className: 'linker'

  events:
    'keypress .input'   : 'updateOnEnter'
    'keyup .input'   : 'autocomplete'
    'keydown'   : 'selectResult'
    'hover ul.autocomplete li' : 'hoverSelect'
    'click ul.autocomplete li' : 'addFromAutoComplete'
    'click .edit-icon ' : 'edit'
    'click .edit .cancel' : 'stopEditing'
    'click .blank-slate' : 'edit'
    'click .name .delete' : 'delete'

  initialize: ->
    @model.bind('change:' + @options.collection, @render)

    # TODO don't remove existing items to show text input
    # TODO for items with no limit, open up new text area to keep adding if desired
    # TODO when click anywhere other than linker widget, close editing.
    # TODO only show delete icon when in edit mode.

  render: =>
    context = {}

    # Add passed-in settings.
    for k,v of @options
      context[k] = v

    # Add models from ids.
    ids = @model.get(@options.collection)
    context.models = []
    if ids?
      context.models = (app.util.getModel(context.type, id) for id in ids)

    $(@el).html(linkerTemplate(context))

  edit: =>
    @$(@el).addClass "editing"
    @$('ul.autocomplete').empty().hide()
    @$('.input').focus().val('')

  stopEditing: =>
    @$(@el).removeClass "editing"

  addFromAutoComplete: =>
    index = @$('ul.autocomplete li.active').index()
    # If a model isn't selected, the index will return -1.
    if index is -1
      @stopEditing()
      return
    match = @matches[index]

    # Check that id isn't already there.
    ids = @model.get([@options.collection])
    if _.include(ids, match.id) then return

    # If we're at the limit of how models can be linked,
    # remove the first before adding the new one.
    if ids.length >= @options.limit then ids.shift()
    ids.push match.id
    field = {}
    field[@options.collection] = ids

    @model.save(
      field
    )

    # For some reason, the save above isn't triggering the change event.
    @model.trigger('change:' + @options.collection)

    @stopEditing()

  updateOnEnter: (e) ->
    @addFromAutoComplete() if e.keyCode is $.ui.keyCode.ENTER

  autocomplete: (e) =>
    # If the user is trying to navigate the results list, let the selectResult
    # method do its work.
    if _.indexOf([$.ui.keyCode.UP, $.ui.keyCode.DOWN], e.keyCode) isnt -1
      return

    @$('ul.autocomplete').empty().hide()
    collection = @options.type + "s"
    @matches = []
    @matches = app.collections[collection].query @$('.input').val()
    for match in @matches
      @$('ul.autocomplete').append('<li>' + match.highlighted + '</li>')

    @$('ul.autocomplete li').first().addClass('active')
    if @matches.length > 0 then @$('ul.autocomplete').show()

  selectResult: (e) =>
    # Exit editing on escape.
    if e.keyCode is $.ui.keyCode.ESCAPE then @stopEditing()

    if e.keyCode is $.ui.keyCode.DOWN
      @$('ul.autocomplete li.active').removeClass('active').next().addClass('active')
      if @$('ul.autocomplete li.active').length is 0
        @$('ul.autocomplete li').last().addClass('active')
      e.preventDefault()
    if e.keyCode is $.ui.keyCode.UP
      @$('ul.autocomplete li.active').removeClass('active').prev().addClass('active')
      if @$('ul.autocomplete li.active').length is 0
        @$('ul.autocomplete li').first().addClass('active')
      e.preventDefault()

  hoverSelect: (e) =>
    @$('ul.autocomplete li.active').removeClass('active')
    $(e.target).addClass('active')

  delete: (e) =>
    id = @$(e.target).parent().data('id')

    # Add a data-id + data-type to the name so we can identify what we clicked on
    field = {}
    field[@options.collection] = _.without(@model.get([@options.collection]), id)
    @model.save( field )
    return
