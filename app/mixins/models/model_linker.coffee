exports.ModelLinker =
  # constructor: (@model) ->
    # f =
    #   project_links: []
    #   context_links: []
    #   action_links: []
    # @model.save(f)

  createLink: (type, id, temp = false) ->
    links = @get(type + "_links")
    limit = @get(type + "_links_limit")

    # Add id to the array if it isn't already there.
    if _.indexOf(_.pluck(links, 'id'), id) is -1
      id_obj =
        id: id
        created: new Date().toISOString()
        type: type
      links.push id_obj

    # If the links array is over the limit, remove the oldest.
    if links.length > limit and limit isnt 0
      old_link = links.shift()
      old_linked_model = app.util.loadModel(old_link.type, old_link.id, (model) =>
        old_linked_model.deleteLink(@get('type'), @id)
      )


    field = {}
    field[type + "_links"] = links

    if temp then @set field else @save field

    # For some reason, saving here doesn't trigger the change events so we
    # trigger them manually.
    @trigger('change')
    @trigger('change:' + type + "_links")
    app.util.loadModel(type, id, (model) =>
      @trigger('add:' + type + "_link", model)
    )

  deleteLink: (type, id, temp) ->
    # Default to false.
    unless temp? then temp = false

    links = @get(type + "_links")

    new_links = (link for link in links when link.id isnt id)
    # If now empty, the comprehension returns undefined. We don't want that.
    unless new_links? then new_links = []

    field = {}
    field[type + "_links"] = new_links
    if temp then @set field else @save field

    unless temp
      app.util.loadModel(type, id, (model) =>
        @trigger('delete:' + type + "_link", model)
      )

  saveOrderLinkedModels: (link_name, orderedIds) ->
    links = @get(link_name)
    links = _.sortBy links, (link) -> return _.indexOf(orderedIds, link.id)
    field = {}
    field[link_name] = links
    @save field
