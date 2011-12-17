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
    @model.bind('change:' + @options.linking_to + "_links", @render)

    # TODO don't remove existing items to show text input
    # TODO for items with no limit, open up new text area to keep adding if desired
    # TODO when clicking anywhere other than linker widget, close editing.
    # TODO only show delete icon when in edit mode.

  render: =>
    context = {}

    # Add passed-in settings.
    for k,v of @options
      context[k] = v

    # Add models from ids.
    ids = @model.get(@options.linking_to + "_links")
    context.models = []
    if ids?
      context.models = (app.util.getModel(context.linking_to, id.id) for id in ids)

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
    @addNewLink(match.id)

  addNewLink: (linked_id) =>
    @model.linker.create(@options.linking_to, linked_id)
    linkedToModel = app.util.getModel(@options.linking_to, linked_id)
    linkedToModel.linker.create(@model.get('type'), @model.id)

    @stopEditing()

  updateOnEnter: (e) ->
    @addFromAutoComplete() if e.keyCode is $.ui.keyCode.ENTER

  autocomplete: (e) =>
    # If the user is trying to navigate the results list, let the selectResult
    # method do its work.
    if _.indexOf([$.ui.keyCode.UP, $.ui.keyCode.DOWN], e.keyCode) isnt -1
      return

    @$('ul.autocomplete').empty().hide()
    collection = @options.linking_to + "s"
    @matches = []
    @matches = app.collections[collection].query @$('.input').val()
    for match in @matches
      @$('ul.autocomplete').append('<li>' + match.highlighted + '</li>')

    @$('ul.autocomplete li').first().addClass('active')
    if @matches.length > 0 then @$('ul.autocomplete').show()

  selectResult: (e) =>
    # Exit editing on escape.
    if e.keyCode is $.ui.keyCode.ESCAPE then @stopEditing()

    # When the user presses the down arrow, select the next item in the matches.
    if e.keyCode is $.ui.keyCode.DOWN
      @$('ul.autocomplete li.active').removeClass('active').next().addClass('active')
      if @$('ul.autocomplete li.active').length is 0
        @$('ul.autocomplete li').last().addClass('active')
      e.preventDefault()

    # When the user presses the up arrow, select the previous item in the matches.
    if e.keyCode is $.ui.keyCode.UP
      @$('ul.autocomplete li.active').removeClass('active').prev().addClass('active')
      if @$('ul.autocomplete li.active').length is 0
        @$('ul.autocomplete li').first().addClass('active')
      e.preventDefault()

  # Select the item the mouse is hovering over.
  hoverSelect: (e) =>
    @$('ul.autocomplete li.active').removeClass('active')
    $(e.target).addClass('active')

  # When the delete icon is clicked, delete links on both models.
  delete: (e) =>
    id = @$(e.target).parent().data('id')

    @model.linker.delete(@options.linking_to, id)
    linkedToModel = app.util.getModel(@options.linking_to, id)
    linkedToModel.linker.delete(@model.get('type'), @model.id)

class exports.ModelLinker

  constructor: (@model) ->
    # f =
    #   project_links: []
    #   tag_links: []
    #   action_links: []
    # @model.save(f)

  create: (type, id) ->
    links = @model.get(type + "_links")
    limit = @model.get(type + "_links_limit")

    # Add id to the array if it isn't already there.
    if _.indexOf(links, id) is -1
      id_obj =
        id: id
        created: new Date().toISOString()
        type: type
      links.push id_obj

    # If the links array is over the limit, remove the oldest.
    if links.length > limit and limit isnt 0
      old_link = links.shift()
      old_linked_model = app.util.getModel(old_link.type, old_link.id)
      old_linked_model.linker.delete(@model.get('type'), @model.id)


    field = {}
    field[type + "_links"] = links

    @model.save field
    # For some reason, saving here doesn't trigger the change events so we
    # trigger them manually.
    @model.trigger('change')
    @model.trigger('change:' + type + "_links")

  delete: (type, id) ->
    links = @model.get(type + "_links")

    new_links = (link for link in links when link.id isnt id)
    # If now empty, the comprehension returns undefined. We don't want that.
    unless new_links? then new_links = []

    field = {}
    field[type + "_links"] = new_links
    @model.save field
