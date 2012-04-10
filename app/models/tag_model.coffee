ModelLinker = require('mixins/models/model_linker').ModelLinker
GetHtml = require('mixins/models/get_html').GetHtml
DeleteModel = require('mixins/models/delete_model').DeleteModel
ClearModel = require('mixins/models/clear_model').ClearModel

class exports.Tag extends Backbone.Model

  defaults:
    name: 'Loading...'
    type: 'tag'
    project_links_limit: 0
    action_links_limit: 0
    project_links: []
    action_links: []

  initialize: ->
    # Set next color from color_palette if tag is new.
    unless @get('color_palette')?
      if app.collections.tags.length > 0
        max = _.max(app.collections.tags.pluck('color_palette'))
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
exports.Tag.prototype = _.extend exports.Tag.prototype,
  ModelLinker, GetHtml, DeleteModel, ClearModel
