addNewModelTemplate = require('templates/add_new_model')
ExpandingTextareaView = require('widgets/expanding_textarea/expanding_textarea_view').ExpandingTextareaView

class exports.AddNewModelView extends Backbone.View

  className: 'add-new-model'

  events:
    'keypress .input' : 'saveOnEnter'
    'keydown' : 'escapeEditing'
    'click .add' : 'save'
    'click .cancel' : 'stopEditing'
    'click .blank-slate' : 'showForm'

  render: =>
    context = {}
    for k,v of @options
      context[k] = v

    context['blank_slate_text'] = "Add " + context.type
    @$el.html(addNewModelTemplate(context))
    @logChildView new ExpandingTextareaView(
      el: @$('.expanding-textarea')
      placeholder: "Add new " + context.type
    ).render()
    @$el.addClass('add-new-model')
    @

  saveOnEnter: (e) =>
    if e.keyCode is $.ui.keyCode.ENTER
      @save()
      return false

  save: =>
    # Save new model
    collection = @options.type + "s"
    newModel = {}
    newModel = app.util.modelFactory(@options.type)
    # TODO figure out why in the world project_links
    # has a value the second time through which causes things to fail
    # unless it's set to nothing.
    newModel.set("project_links": [])
    newModel.set("tag_links": [])
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
      @addAutoLinks(model, false)
    })

  newAttributes: =>
    attributes = {}
    attributes.name = @$("textarea").val()
    @$('.expanding-textarea textarea').val('')
    @$('.expanding-textarea .textareaClone div').empty()
    return attributes

  addAutoLinks: (model, temp) ->
    # Add any links.
    unless @options.links? then return
    for link in @options.links
      if temp
        linked_model = app.util.loadModelSynchronous(link.type, link.id)
        # Create link with the model's temporary cid.
        linked_model.createLink(model.get('type'), model.cid, true)
        model.createLink(link.type, link.id, true)
      else
        linked_model = app.util.loadModelSynchronous(link.type, link.id)
        # Delete the temporary cid-based link.
        linked_model.deleteLink(model.get('type'), model.cid, true)
        # Create links on the linked model.
        linked_model.createLink(model.get('type'), model.id)

  escapeEditing: (e) =>
    if e.keyCode is 27
      @stopEditing()

  stopEditing: =>
    @$('.expanding-textarea .input').blur().val('')
    @hideButtons()

  showForm: =>
    @$('.blank-slate').hide()
    @$('.focused').show()
    @$('.expanding-textarea').show()
    @$('textarea').focus()

  hideButtons: =>
    @$('.blank-slate').show()
    @$('.focused').hide()
    @$('.expanding-textarea').hide()
