ActionView = require('views/action_view').ActionView
actionsTemplate = require('templates/actions')

class exports.ActionsView extends Backbone.View

  id: 'actions-view'

  initialize: ->
    app.collections.actions.bind 'add', @addOne
    app.collections.actions.bind 'reset', @addAll

  render: ->
    $(@el).html actionsTemplate()
    @

  addOne: (action) =>
    view = new ActionView model: action
    $(@el).find("#actions").append view.render().el

  addAll: =>
    app.collections.actions.each @addOne
