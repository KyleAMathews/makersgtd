linkerTemplate = require('templates/linker')
Autocomplete = require('mixins/views/autocomplete').Autocomplete

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
    @bindTo(@model, 'change:' + @options.linking_to + "_links", @render)

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
    links = @model.get(@options.linking_to + "_links")
    context.models = []
    if links.length > 0
      ids = (link.id for link in links)
      app.util.loadMultipleModels context.linking_to, ids, (models) =>
        context.models = models

        $(@el).html(linkerTemplate(context))
        @

    else
      $(@el).html(linkerTemplate(context))
      @

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
    @model.createLink(@options.linking_to, linked_id)
    linkedToModel = app.util.loadModel(@options.linking_to, linked_id)
    linkedToModel.createLink(@model.get('type'), @model.id)

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

  # When the delete icon is clicked, delete links on both models.
  delete: (e) =>
    id = @$(e.target).parent().data('id')

    @model.deleteLink(@options.linking_to, id)
    linkedToModel = app.util.loadModel(@options.linking_to, id)
    linkedToModel.deleteLink(@model.get('type'), @model.id)

# Add Mixins
exports.LinkerView.prototype = _.extend exports.LinkerView.prototype,
  Autocomplete
