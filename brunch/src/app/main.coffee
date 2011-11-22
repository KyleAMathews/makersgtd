window.app = {}
app.routers = {}
app.models = {}
app.collections = {}
app.views = {}

Actions = require('collections/actions_collection').Actions
Projects = require('collections/projects_collection').Projects
Tags = require('collections/tags_collection').Tags

MainRouter = require('routers/main_router').MainRouter
HomeView = require('views/home_view').HomeView
NewActionView = require('views/new_action_view').NewActionView
ActionsView = require('views/actions_view').ActionsView

# app bootstrapping on document ready
$(document).ready ->
  app.initialize = ->
    app.collections.actions = new Actions()
    app.collections.projects = new Projects()
    app.collections.tags = new Tags()

    app.routers.main = new MainRouter()
    app.views.home = new HomeView()
    app.views.newAction = new NewActionView()
    app.views.actions = new ActionsView()

    app.routers.main.navigate 'home', true if Backbone.history.getFragment() is ''
  app.initialize()
  Backbone.history.start()

#represent character bindings as tree, once enter in tree, don't exit until reach leaf.

#if next keystroke doesn't match something, exit and start over again.

#e.g.
#     _i - call function navigateInbox
#   _|
#g |_
#    |_n - call function navigateNextActions
