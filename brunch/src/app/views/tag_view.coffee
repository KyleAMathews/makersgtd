tagTemplate = require('templates/tag')
SubCollection = require('collections/sub_collection').SubCollection
pv = require('views/projects_view')

class exports.TagView extends Backbone.View

  className: 'tag-list-item'

  initialize: ->
    # We use bindAll when we're using a mixin that's called by jquery.
    _.bindAll(@)
    @bindTo(@model, 'change', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    json.url = @model.iurl()
    @$(@el).html(tagTemplate(tag: json))
    # TODO change this to notDoneProjects.
    if @options.projects and @model.get('project_links').length > 0
      subProjects = new SubCollection [],
        linkedModel: @model
        link_name: 'project_links'
        link_type: 'project'

      @logChildView new pv.ProjectsView(
        el: @$('.projects')
        collection: subProjects
        tag: @model.id
        actions: @options.actions
      ).render()
    @
