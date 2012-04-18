ActionFullView = require('views/action_full_view').ActionFullView
ProjectFullView = require('views/project_full_view').ProjectFullView
ContextFullView = require('views/context_full_view').ContextFullView

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
    switch newModel.type
      when 'action'
        if c_models.context? and _isConnected('context', c_models.context.id, newModel)
          newModels.context = c_models.context
        else
          newModels.context = ancestors.context
        if c_models.project? and _isConnected('project', c_models.project.id, newModel)
          newModels.project = c_models.project
        else
          newModels.project = ancestors.project
        newModels.action = newModel
      when 'project'
        if c_models.context? and _isConnected('context', c_models.context.id, newModel)
          newModels.context = c_models.context
        else
          newModels.context = ancestors.context
        newModels.project = newModel
        if c_models.action? and _isConnected('action', c_models.action.id, newModel)
          if _.find(newModel.get('action_links'), (action) -> c.models.action.id is action.id)
            newModels.action = c.models.action
      when 'context'
        newModels.context = newModel
        if c_models.project? and _isConnected('project', c_models.project.id, newModel)
          if _.find(newModel.get('project_links'), (project) -> c.models.project.id is project.id)
            newModels.project = c.models.project
        if c_models.action? and _isConnected('action', c_models.action.id, newModel)
          if _.find(newModel.get('action_links'), (action) -> c.models.action.id is action.id)
            newModels.action = c.models.action

    # Render the panes in order from contexts to actions.
    panes = [app.pane1, app.pane2, app.pane3]
    if newModels.context
      contextFullView = new ContextFullView model: newModels.context
      panes.shift().show(contextFullView)
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
  c_models.context = _.find(panes, (model) -> return model.type is 'context')
  c_models.project = _.find(panes, (model) -> return model.type is 'project')
  c_models.action = _.find(panes, (model) -> return model.type is 'action')

  return c_models

# Fetch ancestors of this model. Prefer the project's context not the actions context.
_getAncestors = (model, callback) ->
  if model.get('project_links')?.length > 0
    project_id = model.get('project_links').slice(0,1)[0].id
    app.util.loadModel 'project', project_id, (project) ->
      if project.get('context_links').length > 0
        context_id = project.get('context_links').slice(0,1)[0].id
        app.util.loadModel 'context', context_id, (context) ->
          callback { project: project, context: context }
      else
        callback { project: project }

  else if model.get('context_links')?.length > 0
    context_id = model.get('context_links').slice(0,1)[0].id
    app.util.loadModel 'context', context_id, (context) ->
      callback { context: context }

  else
    callback {}

_viewFactory = (model) ->
  switch model.type
    when 'action' then return new ActionFullView model: model
    when 'project' then return new ProjectFullView model: model
    when 'context' then return new ContextFullView model: model

_isConnected = (type, id, model) ->
  switch model.type
    when 'context'
      return _.include(model.get(type + "_links"), id)
    when 'project'
      return _.include(model.get(type + "_links"), id)
    when 'action'
      # Contexts can be connected either directly or through the actions project.
      if type is 'context'
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
