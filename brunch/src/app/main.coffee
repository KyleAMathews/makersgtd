window.app = {}
app.routers = {}
app.models = {}
app.collections = {}
app.views = {}

Actions = require('collections/actions_collection').Actions
MainRouter = require('routers/main_router').MainRouter
HomeView = require('views/home_view').HomeView
NewActionView = require('views/new_action_view').NewActionView
ActionsView = require('views/actions_view').ActionsView

# app bootstrapping on document ready
$(document).ready ->
  app.initialize = ->
    app.collections.actions = new Actions()

    app.routers.main = new MainRouter()
    app.views.home = new HomeView()
    app.views.newAction = new NewActionView()
    app.views.actions = new ActionsView()

    app.routers.main.navigate 'home', true if Backbone.history.getFragment() is ''
  app.initialize()
  Backbone.history.start()
