window.app = {}
app.routers = {}
app.models = {}
app.collections = {}
app.views = {}

Actions = require('collections/actions_collection').Actions
Projects = require('collections/projects_collection').Projects
Tags = require('collections/tags_collection').Tags

MainRouter = require('routers/main_router').MainRouter

# Actions
NewActionView = require('views/new_action_view').NewActionView
ActionsView = require('views/actions_view').ActionsView
DoneActionsView = require('views/done_actions_view').DoneActionsView

# Projects
NewProjectView = require('views/new_project_view').NewProjectView
ProjectsView = require('views/projects_view').ProjectsView
DoneProjectsView = require('views/done_projects_view').DoneProjectsView

# Tags
NewTagView = require('views/new_tag_view').NewTagView
TagsView = require('views/tags_view').TagsView

# app bootstrapping on document ready
$(document).ready ->
  app.initialize = ->
    app.collections.actions = new Actions()
    app.collections.projects = new Projects()
    app.collections.tags = new Tags()

    app.routers.main = new MainRouter()

    app.views.newAction = new NewActionView()
    app.views.actions = new ActionsView()
    app.views.doneActions = new DoneActionsView()

    app.views.newProject = new NewProjectView()
    app.views.projects = new ProjectsView()
    app.views.doneProjects = new DoneProjectsView()

    app.views.newTag = new NewTagView()
    app.views.tags = new TagsView()

    # GET models from server.
    # Don't initialize router until all the collection fetches have returned.
    successCounter = ->
      counter = 0
      return {
        add: ->
          counter += 1
          if counter is 3
            app.routers.main.navigate 'next-actions', true if Backbone.history.getFragment() is ''
            Backbone.history.start()
      }
    counter = successCounter()

    app.collections.actions.fetch success: => counter.add()
    app.collections.projects.fetch success: => counter.add()
    app.collections.tags.fetch success: => counter.add()

  app.initialize()

#represent character bindings as tree, once enter in tree, don't exit until reach leaf.
# Allow for global states, e.g. normal, input (don't do anything), a model is checked, etc
# global states in stack. Normal is always active. If model is active, it can choose
# which keys to override. If it doesn't override something, then things fallback
# to the next stack.

#if next keystroke doesn't match something, exit and start over again.

#e.g.
#     _i - call function navigateInbox
#   _|
#g |_
#    |_n - call function navigateNextActions
