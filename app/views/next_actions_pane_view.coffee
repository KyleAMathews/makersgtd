projectsTemplate = require('templates/projects')
nextActionsPaneTemplate = require('templates/next_actions_pane')
AddNewModelView = require('views/add_new_model_view').AddNewModelView
ActionView = require('views/action_view').ActionView
TagView = require('views/tag_view').TagView

class exports.NextActionsPaneView extends Backbone.View

  id: 'next-actions-pane-view'

  initialize: ->
    @bindTo app.collections.actions, 'add', @appendToInbox

  render: ->
    @$el.html(nextActionsPaneTemplate())
    @renderInbox()

    @logChildView new AddNewModelView(
      el: @$('.add-new-action')
      type: 'action'
    ).render()

    for tag in app.collections.tags.models
      if tag.notDoneActions().length > 0
        @logChildView tagView = new TagView
          model: tag
          projects: true
          actions: true
        @$el.append tagView.render().el
    @

  renderInbox: =>
    inboxActions = app.collections.actions.filter( (action) ->
      if action.get('tag_links').length is 0 and action.get('project_links').length is 0
        return true
      else
        return false
    )
    if inboxActions.length > 0
      @$el.find('#inbox ul.inbox-actions').empty()
    for action in inboxActions
      @logChildView view = new ActionView model: action
      @$el.find("#inbox ul.inbox-actions").append view.render().el

  appendToInbox: (action) =>
    if action.get('tag_links').length is 0 and action.get('project_links').length is 0
      @logChildView view = new ActionView model: action
      @$el.find("#inbox ul.inbox-actions").append view.render().el

