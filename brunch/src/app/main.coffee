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
    app.collections.actions.fetch()
    app.collections.projects.fetch()
    app.collections.tags.fetch()

    app.routers.main.navigate 'next-actions', true if Backbone.history.getFragment() is ''
  app.initialize()
  Backbone.history.start()

#represent character bindings as tree, once enter in tree, don't exit until reach leaf.

#if next keystroke doesn't match something, exit and start over again.

#e.g.
#     _i - call function navigateInbox
#   _|
#g |_
#    |_n - call function navigateNextActions
