projectsTemplate = require('templates/projects')
AddNewModelView = require('views/add_new_model_view').AddNewModelView
TagView = require('views/tag_view').TagView

class exports.NextActionsPaneView extends Backbone.View

  className: 'collection-view'
  id: 'next-actions-pane-view'

  render: ->
    # TODO this can either render multiple tags (projects page)
    # or be for just one (tag page)
    # but in either case, it loads projects by tag
    # and then renders those projects.
    for tag in app.collections.tags.models
      if tag.notDoneActions().length > 0
        @logChildView tagView = new TagView
          model: tag
          projects: true
          actions: true
        $(@el).append tagView.render().el
