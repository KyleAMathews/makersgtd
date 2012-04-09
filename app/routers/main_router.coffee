ActionFullView = require('views/action_full_view').ActionFullView
ProjectFullView = require('views/project_full_view').ProjectFullView
TagFullView = require('views/tag_full_view').TagFullView
AddNewModelView = require('views/add_new_model_view').AddNewModelView

# Tags
TagsView = require('views/tags_view').TagsView

class exports.MainRouter extends Backbone.Router
  routes :
    "projects": "projects"
    "tags": "tags"
    "actions/:id": "actionView"
    "projects/:id": "projectView"
    "tags/:id": "tagView"

  tags: ->
    tags = new TagsView(
      collection: app.collections.tags
    )

    $('nav li a.active').removeClass('active')
    $('nav li a.tags').addClass('active')

    app.pane0.show(tags)

  actionView: (id) ->
    app.util.loadModel 'action', id, (action) ->
      $('#simple-gtd-app h1.title').hide()

      if action?
        app.util.renderPanes action

  projectView: (id) ->
    app.util.loadModel 'project', id, (project) ->
      $('#simple-gtd-app h1.title').hide()

      if project?
        app.util.renderPanes project

  tagView: (id) ->
    app.util.loadModel 'tag', id, (tag) ->
      $('#simple-gtd-app h1.title').hide()

      if tag?
        app.util.renderPanes tag
