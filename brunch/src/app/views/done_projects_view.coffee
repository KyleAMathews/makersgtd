ProjectView = require('views/project_view').ProjectView
projectsTemplate = require('templates/projects')

class exports.DoneProjectsView extends Backbone.View

  id: 'done-projects-view'

  initialize: ->
    app.collections.projects.bind 'reset', @addAll
    app.collections.projects.bind 'change:done', @changeDoneState

  render: ->
    $(@el).html projectsTemplate()
    @addAll()
    @

  addOne: (project) =>
    view = new ProjectView model: project
    $(@el).find("#projects").append view.render().el

  addAll: =>
    @$('#projects').empty()
    @addOne project for project in app.collections.projects.done()
