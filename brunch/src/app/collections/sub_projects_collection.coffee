Project = require('models/project_model').Project

class exports.SubProjects extends Backbone.Collection

  model: Project

  comparator: (project) ->
    project.get 'order'

  done: ->
    items = @filter( (project) ->
      project.get 'done'
    )
    items = _.sortBy items, (item) -> return item.get('completed')
    return items

  notDone: ->
    items = @filter( (project) ->
      not project.get 'done'
    )
    items = _.sortBy items, (item) -> return item.get('order')
    return items

