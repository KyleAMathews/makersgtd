class exports.SubCollection extends Backbone.Collection

  initialize: (models, options) ->
    # Load models from passed in IDs
    @options = options
    links = @options.linkedModel.get(@options.link_name)
    models = []
    if links.length > 0
      ids = (link.id for link in links)
      app.util.loadMultipleModels @options.link_type, ids, (models) =>
        @reset(models)

  done: ->
    items = @filter (model) ->
      model.get 'done'
    items = _.sortBy items, (item) -> return item.get('completed')
    return items

  notDone: ->
    items = @filter (model) ->
      not model.get 'done'
    return items

  saveOrder: (orderedIds) ->
    # Save the new order of the linked models to the parent model
    @options.linkedModel.saveOrderLinkedModels(@options.link_name, orderedIds)
