tagTemplate = require('templates/tag')
SubCollection = require('collections/sub_collection').SubCollection
pv = require('views/projects_view')
ActionsView = require('views/actions_view').ActionsView

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
    @$el.html(tagTemplate(tag: json))

    if @options.actions
      # Render the tag's loose actions, i.e. those without a project.
      # This is labeled in the UI, "Inbox"
      doneFilter = (action) ->
        if action.get('project_links').length > 0
          return false
        else
          return true

      inboxActions = new SubCollection null,
        linkedModel: @model
        link_name: 'action_links'
        link_type: 'action'
        filter: doneFilter

      @logChildView new ActionsView(
        el: @$('.inbox')
        collection: inboxActions
      ).render()

    if @options.projects and @model.get('project_links').length > 0
      subProjects = new SubCollection null,
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
