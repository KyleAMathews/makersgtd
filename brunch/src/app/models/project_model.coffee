ModelLinker = require('mixins/models/model_linker').ModelLinker
ToggleDoneness = require('mixins/models/toggle_doneness').ToggleDoneness
GetHtml = require('mixins/models/get_html').GetHtml
DeleteModel = require('mixins/models/delete_model').DeleteModel
ClearModel = require('mixins/models/clear_model').ClearModel

class exports.Project extends Backbone.Model

  defaults:
    name: 'Loading...'
    done: false
    type: 'project'
    action_links_limit: 0
    tag_links_limit: 0
    action_links: []
    tag_links: []

# Add Mixins
exports.Project.prototype = _.extend exports.Project.prototype,
  ModelLinker, ToggleDoneness, GetHtml, DeleteModel, ClearModel
