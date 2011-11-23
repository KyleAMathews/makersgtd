ActionView = require('views/action_view').ActionView
actionsTemplate = require('templates/actions')

class exports.DoneActionsView extends Backbone.View

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
    @addOne action for action in app.collections.actions.done()

  changeDoneState: (action) =>
    if action.get('done')
      @addOne action
    else
      @render().addAll()
