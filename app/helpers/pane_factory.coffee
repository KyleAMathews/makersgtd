ActionFullView = require('views/action_full_view').ActionFullView
ProjectFullView = require('views/project_full_view').ProjectFullView
TagFullView = require('views/tag_full_view').TagFullView

app.util.renderPanes = (newModel) ->
  # Mobile devices just get one pane.
  if $(window).width() < 400
    _renderSolo(newModel)
    return

  # Get the models from the current panes.
  c_models = _getCurrentModels()

  ancestors = _getAncestors newModel, (ancestors) ->
    newModels = {}
    # Merge Ancestors of the new model and the current panes.
    # Current panes are prefered if they're connected to the new model.
    switch newModel.get 'type'
      when 'action'
        if c_models.tag? and _isConnected('tag', c_models.tag.id, newModel)
          newModels.tag = c_models.tag
        else
          newModels.tag = ancestors.tag
        if c_models.project? and _isConnected('project', c_models.project.id, newModel)
          newModels.project = c_models.project
        else
          newModels.project = ancestors.project
        newModels.action = newModel
      when 'project'
        if c_models.tag? and _isConnected('tag', c_models.tag.id, newModel)
          newModels.tag = c_models.tag
        else
          newModels.tag = ancestors.tag
        newModels.project = newModel
        if c_models.action? and _isConnected('action', c_models.action.id, newModel)
          if _.find(newModel.get('action_links'), (action) -> c.models.action.id is action.id)
            newModels.action = c.models.action
      when 'tag'
        newModels.tag = newModel
        if c_models.project? and _isConnected('project', c_models.project.id, newModel)
          if _.find(newModel.get('project_links'), (project) -> c.models.project.id is project.id)
            newModels.project = c.models.project
        if c_models.action? and _isConnected('action', c_models.action.id, newModel)
          if _.find(newModel.get('action_links'), (action) -> c.models.action.id is action.id)
            newModels.action = c.models.action

    # Render the panes in order from tags to actions.
    panes = [app.pane1, app.pane2, app.pane3]
    if newModels.tag
      tagFullView = new TagFullView model: newModels.tag
      panes.shift().show(tagFullView)
    if newModels.project
      projectFullView = new ProjectFullView model: newModels.project
      panes.shift().show(projectFullView)
    if newModels.action
      actionFullView = new ActionFullView model: newModels.action
      panes.shift().show(actionFullView)

    # Hide any remaining panes.
    for pane in panes
      pane.hide()

_renderSolo = (model) ->
  view = _viewFactory(model)
  app.pane0.show(view)
  app.pane1.hide()
  app.pane2.hide()
  app.pane3.hide()

_getCurrentModels = ->
  panes = []
  if app.pane1.getModel()
    panes.push app.pane1.getModel()
  if app.pane2.getModel()
    panes.push app.pane2.getModel()
  if app.pane3.getModel()
    panes.push app.pane3.getModel()

  c_models = {}
  c_models.tag = _.find(panes, (model) -> return model.get('type') is 'tag')
  c_models.project = _.find(panes, (model) -> return model.get('type') is 'project')
  c_models.action = _.find(panes, (model) -> return model.get('type') is 'action')

  return c_models

# Fetch ancestors of this model. Prefer the project's tag not the actions tag.
_getAncestors = (model, callback) ->
  if model.get('project_links')?.length > 0
    project_id = model.get('project_links').slice(0,1)[0].id
    app.util.loadModel 'project', project_id, (project) ->
      if project.get('tag_links').length > 0
        tag_id = project.get('tag_links').slice(0,1)[0].id
        app.util.loadModel 'tag', tag_id, (tag) ->
          callback { project: project, tag: tag }
      else
        callback { project: project }

  else if model.get('tag_links')?.length > 0
    tag_id = model.get('tag_links').slice(0,1)[0].id
    app.util.loadModel 'tag', tag_id, (tag) ->
      callback { tag: tag }

  else
    callback {}

_viewFactory = (model) ->
  switch model.get('type')
    when 'action' then return new ActionFullView model: model
    when 'project' then return new ProjectFullView model: model
    when 'tag' then return new TagFullView model: model

_isConnected = (type, id, model) ->
  switch model.get('type')
    when 'tag'
      return _.include(model.get(type + "_links"), id)
    when 'project'
      return _.include(model.get(type + "_links"), id)
    when 'action'
      # Tags can be connected either directly or through the actions project.
      if type is 'tag'
        if _.include(model.get(type + "_links"), id)
          return true
        else if model.get('project_links').length > 0
          project_id = model.get('project_links').slice(0,1)[0].id
          app.util.loadModel 'project', project_id, (project) ->
            return _.include(model.get(type + "_links"), id)
        else
          return false
      else
        return _.include(model.get(type + "_links"), id)
