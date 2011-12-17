ActionFullView = require('views/action_full_view').ActionFullView
ProjectFullView = require('views/project_full_view').ProjectFullView
TagFullView = require('views/tag_full_view').TagFullView

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

class exports.MainRouter extends Backbone.Router
  routes :
    "next-actions": "nextActions"
    "projects": "projects"
    "tags": "tags"
    "actions/:id": "actionView"
    "projects/:id": "projectView"
    "tags/:id": "tagView"

  nextActions: ->
    actions = new ActionsView( collection: app.collections.actions )
    doneActions = new DoneActionsView( collection: app.collections.actions )
    newAction = new NewActionView()

    $('#simple-gtd-app .content').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.next-actions').addClass('active')

    $('#simple-gtd-app h1.title').html 'Next Actions'
    $('#simple-gtd-app .content').append actions.render().el
    $('#simple-gtd-app .content').append newAction.render().el
    $('#simple-gtd-app .content').append doneActions.render().el

  projects: ->
    newProject = new NewProjectView()
    projects = new ProjectsView( collection: app.collections.projects )
    doneProjects = new DoneProjectsView( collection: app.collections.projects )
    $('#simple-gtd-app .content').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.projects').addClass('active')

    $('#simple-gtd-app h1.title').html 'Projects'
    $('#simple-gtd-app .content').append projects.render().el
    $('#simple-gtd-app .content').append newProject.render().el
    $('#simple-gtd-app .content').append doneProjects.render().el

  tags: ->
    newTag = new NewTagView()
    tags = new TagsView()
    $('#simple-gtd-app .content').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.tags').addClass('active')

    $('#simple-gtd-app h1.title').html 'Filters'
    $('#simple-gtd-app .content').append tags.render().el
    $('#simple-gtd-app .content').append newTag.render().el

  actionView: (id) ->
    action = app.collections.actions.get(id)
    $('#simple-gtd-app h1.title').html 'Action'

    $('nav li a.active').removeClass('active')
    $('nav li a.next-actions').addClass('active')

    if action?
      actionFullView = new ActionFullView model: action
      $('#simple-gtd-app .content').html actionFullView.render().el

  projectView: (id) ->
    project = app.collections.projects.get(id)

    $('#simple-gtd-app h1.title').html 'Project'

    $('nav li a.active').removeClass('active')
    $('nav li a.projects').addClass('active')

    if project?
      projectFullView = new ProjectFullView model: project
      $('#simple-gtd-app .content').html projectFullView.render().el

  tagView: (id) ->
    tag = app.collections.tags.get(id)

    $('#simple-gtd-app h1.title').html 'Tag'

    $('nav li a.active').removeClass('active')
    $('nav li a.tags').addClass('active')

    if tag?
      tagView = new TagFullView model: tag
      $('#simple-gtd-app .content').html tagView.render().el
