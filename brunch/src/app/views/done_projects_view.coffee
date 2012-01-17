ProjectView = require('views/project_view').ProjectView
projectsTemplate = require('templates/projects')

class exports.DoneProjectsView extends Backbone.View

  className: 'collection-view'
  id: 'done-projects-view'

  initialize: ->
    @bindTo(@collection, 'reset', @addAll)
    @bindTo(@collection, 'change:done', @changeDoneState)

  render: ->
    $(@el).html projectsTemplate(
      options: @options
      length: @collection.done().length
    )
    @addAll()
    # Remove the last border.
    @$('li:last').css('border-color', 'rgba(0,0,0,0)')
    @

  addOne: (project) =>
    @logChildView view = new ProjectView model: project
    $(@el).find("#projects").append view.render().el

  addAll: =>
    @$('#projects').empty()
    projects = @collection.done()
    projects = _.sortBy projects, (project) -> project.get('completed')
    projects.reverse()
    @addOne project for project in projects
