ActionFullView = require('views/action_full_view').ActionFullView
ProjectFullView = require('views/project_full_view').ProjectFullView
TagFullView = require('views/tag_full_view').TagFullView

class exports.MainRouter extends Backbone.Router
  routes :
    "next-actions": "nextActions"
    "projects": "projects"
    "tags": "tags"
    "actions/:id": "actionView"
    "projects/:id": "projectView"
    "tags/:id": "tagView"

  nextActions: ->
    $('#simple-gtd-app .content').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.next-actions').addClass('active')

    $('#simple-gtd-app h1.title').html 'Next Actions'
    $('#simple-gtd-app .content').append app.views.actions.render().el
    $('#simple-gtd-app .content').append app.views.newAction.render().el
    $('#simple-gtd-app .content').append app.views.doneActions.render().el

  projects: ->
    $('#simple-gtd-app .content').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.projects').addClass('active')

    $('#simple-gtd-app h1.title').html 'Projects'
    $('#simple-gtd-app .content').append app.views.projects.render().el
    $('#simple-gtd-app .content').append app.views.newProject.render().el
    $('#simple-gtd-app .content').append app.views.doneProjects.render().el

  tags: ->
    $('#simple-gtd-app .content').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.tags').addClass('active')

    $('#simple-gtd-app h1.title').html 'Filters'
    $('#simple-gtd-app .content').append app.views.tags.render().el
    $('#simple-gtd-app .content').append app.views.newTag.render().el

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
