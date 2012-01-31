projectsTemplate = require('templates/projects')
nextActionsPaneTemplate = require('templates/next_actions_pane')
AddNewModelView = require('views/add_new_model_view').AddNewModelView
ActionView = require('views/action_view').ActionView
TagView = require('views/tag_view').TagView

class exports.NextActionsPaneView extends Backbone.View

  id: 'next-actions-pane-view'

  render: ->
    @$el.html(nextActionsPaneTemplate())
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

    for tag in app.collections.tags.models
      if tag.notDoneActions().length > 0
        @logChildView tagView = new TagView
          model: tag
          projects: true
          actions: true
        @$el.append tagView.render().el

    _.defer ->
      $('.tag-list-item .tag').each( (index) ->
        colorScheme = app.colorCombos[index]
        for background,color of colorScheme
          $(@).css( background: background )
          $(@).css( color: color )
      )
    @
