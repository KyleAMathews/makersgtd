Project = require('models/project_model').Project

class exports.Projects extends Backbone.Collection

  model: Project
  url: '/projects'

  initialize: ->
    console.log 'initing projects collection'

  done: ->
    items = @filter( (action) ->
      action.get 'done'
    )
    # return _.sortBy(items, (item) -> return item.get('order'))
    return items

  notDone: ->
    items = @filter( (action) ->
      not action.get 'done'
    )
    # return _.sortBy(items, (item) -> return item.get('order'))
    return items
