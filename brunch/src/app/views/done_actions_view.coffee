ActionView = require('views/action_view').ActionView
actionsTemplate = require('templates/actions')

class exports.DoneActionsView extends Backbone.View

  className: 'collection-view'
  id: 'done-actions-view'

  initialize: ->
    app.collections.actions.bind 'reset', @addAll
    app.collections.actions.bind 'change:done', @changeDoneState

  render: ->
    $(@el).html actionsTemplate()
    @addAll()
    @

  addOne: (action) =>
    view = new ActionView model: action
    $(@el).find("#actions").append view.render().el

  addAll: =>
    @$('#actions').empty()
    actions = app.collections.actions.done()
    actions = _.sortBy actions, (action) -> action.get('completed')
    actions.reverse()
    @addOne action for action in actions

  changeDoneState: (action) =>
    if action.get('done')
      @addOne action
    else
      @render().addAll()
