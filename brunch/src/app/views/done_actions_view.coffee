ActionView = require('views/action_view').ActionView
actionsTemplate = require('templates/actions')

class exports.DoneActionsView extends Backbone.View

  className: 'collection-view'
  id: 'done-actions-view'

  initialize: ->
    @collection.bind 'reset', @render
    @collection.bind 'change:done', @render

  render: =>
    $(@el).html actionsTemplate(
      options: @options
      length: @collection.length
    )
    @addAll()
    # Remove the last border.
    @$('li:last').css('border-color', 'rgba(0,0,0,0)')
    @

  addOne: (action) =>
    view = new ActionView model: action
    $(@el).find("#actions").append view.render().el

  addAll: =>
    @$('#actions').empty()
    actions = @collection.done()
    actions = _.sortBy actions, (action) -> action.get('completed')
    actions.reverse()
    @addOne action for action in actions
