ModelLinker = require('mixins/models/model_linker').ModelLinker
GetHtml = require('mixins/models/get_html').GetHtml
DeleteModel = require('mixins/models/delete_model').DeleteModel
ClearModel = require('mixins/models/clear_model').ClearModel

class exports.Context extends Backbone.Model

  defaults:
    name: 'Loading...'
    type: 'context'
    project_links_limit: 0
    action_links_limit: 0
    project_links: []
    action_links: []

  initialize: ->
    @type = "context"
    # Set next color from color_palette if context is new.
    unless @get('color_palette')?
      if app.collections.contexts.length > 0
        max = _.max(app.collections.contexts.pluck('color_palette'))
        newPalette = max % app.colorPalette.length + 1
      else
        newPalette = 0
      @set( color_palette: newPalette )

  notDoneActions: ->
    actions = []
    for link in @get('action_links')
      action = app.util.loadModelSynchronous('action', link.id)
      if action and not action.get('done')
        actions.push action

    return actions

# Add Mixins
exports.Context.prototype = _.extend exports.Context.prototype,
  ModelLinker, GetHtml, DeleteModel, ClearModel
