ActionFullView = require('views/action_full_view').ActionFullView
ProjectFullView = require('views/project_full_view').ProjectFullView
ContextFullView = require('views/context_full_view').ContextFullView
AddNewModelView = require('views/add_new_model_view').AddNewModelView
SettingsView = require 'views/settings_view'

# Contexts
ContextsView = require('views/contexts_view').ContextsView

class exports.MainRouter extends Backbone.Router
  routes :
    "projects": "projects"
    "contexts": "contexts"
    "actions/:id": "actionView"
    "projects/:id": "projectView"
    "contexts/:id": "contextView"
    "settings": "settings"

  contexts: ->
    contexts = new ContextsView(
      collection: app.collections.contexts
    )
    app.pane0.show(contexts)

  actionView: (id) ->
    app.util.loadModel 'action', id, (action) ->
      $('#simple-gtd-app h1.title').hide()

      if action?
        app.util.renderPanes action

  projectView: (id) ->
    app.util.loadModel 'project', id, (project) ->
      $('#simple-gtd-app h1.title').hide()

      if project?
        app.util.renderPanes project

  contextView: (id) ->
    app.util.loadModel 'context', id, (context) ->
      $('#simple-gtd-app h1.title').hide()

      if context?
        app.util.renderPanes context

  settings: ->
    if app.views.settingsView then app.views.settingsView.close()
    app.views.settingsView = new SettingsView(
      model: app.models.user
    )
    app.views.settingsView.render()
