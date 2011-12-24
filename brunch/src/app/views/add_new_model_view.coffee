addNewModelTemplate = require('templates/add_new_model')
ExpandingAreaView = require('views/expanding_area_view').ExpandingAreaView

class exports.AddNewModelView extends Backbone.View

  className: 'add-new-model'

  events:
    'keypress .input' : 'save'

  render: =>
    context = {}
    for k,v of @options
      context[k] = v

    $(@el).html(addNewModelTemplate(context))
    new ExpandingAreaView(
      el: @$('.expanding-area')
      placeholder: "Add new " + context.type
    ).render()
    @

  save: (e) =>
    if e.keyCode is $.ui.keyCode.ENTER
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
      name = newModel.get('name')
      unless name? and name isnt '' then return

      # TODO Change to use per project or per context ordering
      newOrder = _.max(app.collections.actions.pluck('order')) + 1
      newModel.set( 'order': newOrder )

      app.collections[collection].add newModel
      @addAutoLinks(newModel, true)
      newModel.save({}, { success: (model, response) =>
        @addAutoLinks(model, false)
      })

  newAttributes: ->
    attributes = {}
    attributes.name = @$("textarea").val()
    self = @
    _.defer ->
      self.$('textarea').val('')
      self.$('span').empty()
    return attributes

  addAutoLinks: (model, temp) ->
    # Add any links.
    unless @options.links? then return
    for link in @options.links
      if temp
        linked_model = app.util.getModel(link.type, link.id)
        # Create link with the model's temporary cid.
        linked_model.createLink(model.get('type'), model.cid, true)
      else
        linked_model = app.util.getModel(link.type, link.id)
        # Delete the temporary cid-based link.
        linked_model.deleteLink(model.get('type'), model.cid, true)
        # Create links on the linked model and the originating model.
        linked_model.createLink(model.get('type'), model.id)
        model.createLink(link.type, link.id)
