addNewModelTemplate = require('templates/add_new_model')
ExpandingAreaView = require('views/expanding_area_view').ExpandingAreaView

class exports.AddNewModelView extends Backbone.View

  className: 'add-new-model'

  events:
    'keypress .input' : 'saveOnEnter'
    'keydown' : 'escapeEditing'
    'click .add' : 'save'
    'click .cancel' : 'stopEditing'
    'focus .expanding-area .input' : 'showButtons'

  render: =>
    context = {}
    for k,v of @options
      context[k] = v

    $(@el).html(addNewModelTemplate(context))
    @logChildView new ExpandingAreaView(
      el: @$('.expanding-area')
      placeholder: "Add new " + context.type
    ).render()
    $(@el).addClass('add-new-model')
    @

  saveOnEnter: (e) =>
    if e.keyCode is $.ui.keyCode.ENTER
      @save()

  save: =>
    # Save new model
    collection = @options.type + "s"
    newModel = {}
    newModel = app.util.modelFactory(@options.type)
    # TODO figure out why in the world project_links
    # has a value the second time through which causes things to fail
    # unless it's set to nothing.
    newModel.set("project_links": [])
    for k,v of @newAttributes()
      prop = {}
      prop[k] = v
      newModel.set( prop )

    # Don't save if the name is blank.
    # TODO move this stuff into model validation
    name = newModel.get('name')
    unless name? and name isnt '' then return

    # Remove # or @ from the start of the name.
    firstLetter = name.substring(0,1)
    if firstLetter is "#" or firstLetter is "@"
      newModel.set( name: name.substring(1) )

    # TODO Change to use per project or per context ordering
    newOrder = _.max(app.collections.actions.pluck('order')) + 1
    newModel.set( 'order': newOrder )

    # Add model to the collection immediately so it'll show up in lists right away.
    app.collections[collection].add newModel
    @addAutoLinks(newModel, true)
    newModel.save({}, { success: (model, response) =>
      # Reset fuzzymatcher list now that our model has an id.
      model.collection.addToFuzzymatcher()
      @addAutoLinks(model, false)
    })

  newAttributes: =>
    attributes = {}
    attributes.name = @$("textarea").val()
    self = @
    _.defer ->
      self.$('.expanding-area textarea').val('')
      self.$('.expanding-area .textareaClone div').empty()
    return attributes

  addAutoLinks: (model, temp) ->
    # Add any links.
    unless @options.links? then return
    for link in @options.links
      if temp
        linked_model = app.util.loadModel(link.type, link.id)
        # Create link with the model's temporary cid.
        linked_model.createLink(model.get('type'), model.cid, true)
      else
        linked_model = app.util.loadModel(link.type, link.id)
        # Delete the temporary cid-based link.
        linked_model.deleteLink(model.get('type'), model.cid, true)
        # Create links on the linked model and the originating model.
        linked_model.createLink(model.get('type'), model.id)
        model.createLink(link.type, link.id)

  escapeEditing: (e) =>
    if e.keyCode is 27
      @stopEditing()

  stopEditing: =>
    @$('.expanding-area .input').blur().val('')
    @hideButtons()

  showButtons: =>
    @$('.focused').show()

  hideButtons: =>
    @$('.focused').hide()
