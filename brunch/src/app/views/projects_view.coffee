ProjectView = require('views/project_view').ProjectView
projectsTemplate = require('templates/projects')
AddNewModelView = require('views/add_new_model_view').AddNewModelView
TagView = require('views/tag_view').TagView

class exports.ProjectsView extends Backbone.View

  className: 'collection-view'
  id: 'projects-view'

  initialize: ->
    @bindTo @collection, 'add', @addOne
    @bindTo @collection, 'reset', @render

  render: ->
    $(@el).html projectsTemplate(
      options: @options
    )

    if @options.label?
      $(@el).prepend('<h4 class="label">' + @options.label + '</h4>')
    @addAll()

    if @options.addNewModelForm?
      @logChildView new AddNewModelView(
        el: @$('.add-new-project')
        type: 'project'
      ).render()
    @

  addOne: (project) =>
    @logChildView view = new ProjectView model: project
    @$("ul#projects").append view.render().el

  addAll: =>
    @$('ul#projects').empty()
    @addOne project for project in @collection.notDone()
