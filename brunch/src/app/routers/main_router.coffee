ActionFullView = require('views/action_full_view').ActionFullView

class exports.MainRouter extends Backbone.Router
  routes :
    "next-actions": "nextActions"
    "projects": "projects"
    "tags": "tags"
    "actions/:id": "actionView"

  nextActions: ->
    $('#simple-gtd-app').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.next-actions').addClass('active')

    $('#simple-gtd-app').append '<h1>Next Actions</h1>'
    $('#simple-gtd-app').append app.views.actions.render().el
    $('#simple-gtd-app').append app.views.newAction.render().el
    $('#simple-gtd-app').append app.views.doneActions.render().el

  projects: ->
    $('#simple-gtd-app').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.projects').addClass('active')

    $('#simple-gtd-app').append '<h1>Projects</h1>'
    $('#simple-gtd-app').append app.views.projects.render().el
    $('#simple-gtd-app').append app.views.newProject.render().el
    $('#simple-gtd-app').append app.views.doneProjects.render().el

  tags: ->
    $('#simple-gtd-app').empty()

    $('nav li a.active').removeClass('active')
    $('nav li a.tags').addClass('active')

    $('#simple-gtd-app').append '<h1>Tags</h1>'
    $('#simple-gtd-app').append app.views.tags.render().el
    $('#simple-gtd-app').append app.views.newTag.render().el

  actionView: (id) ->
    app.views.home.render()
    action = app.collections.actions.get(id)
    if action?
      actionView = new ActionFullView model: action
      $('#simple-gtd-app').html actionView.render().el
