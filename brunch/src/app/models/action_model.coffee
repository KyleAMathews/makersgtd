ModelLinker = require('mixins/models/model_linker').ModelLinker
ToggleDoneness = require('mixins/models/toggle_doneness').ToggleDoneness
GetHtml = require('mixins/models/get_html').GetHtml
DeleteModel = require('mixins/models/delete_model').DeleteModel
ClearModel = require('mixins/models/clear_model').ClearModel

class exports.Action extends Backbone.Model

  defaults:
    name: 'Loading...'
    done: false
    order: 100
    type: 'action'
    project_links_limit: 1
    tag_links_limit: 0
    project_links: []
    tag_links: []

  initialize: ->
    @on 'sync', @triggerLinkChange

  triggerLinkChange: =>
    project = app.util.loadModelSynchronous('project', @get('project_links')[0]['id'])
    project.trigger('change:action_links')

    for tag in @get('tag_links')
      tagObj = app.util.loadModelSynchronous('tag', tag['id'])
      tagObj.trigger('change:action_links')

# Add Mixins
exports.Action.prototype = _.extend exports.Action.prototype,
  ModelLinker, ToggleDoneness, GetHtml, DeleteModel, ClearModel
