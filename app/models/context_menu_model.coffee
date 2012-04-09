class exports.ContextMenuModel extends Backbone.Model

  defaults:
    models: []

  add: (model) =>
    models = @get 'models'
    models.push model
    @set 'models': models
    @trigger 'change'
    @trigger 'change:models'

  remove: (model) =>
    models = @get 'models'
    models = (m for m in models when m.id isnt model.id)
    @set 'models': models
    @trigger 'change'
    @trigger 'change:models'
