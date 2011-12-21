ModelLinker = require('mixins/models/model_linker').ModelLinker
ToggleDoneness = require('mixins/models/toggle_doneness').ToggleDoneness
GetHtml = require('mixins/models/get_html').GetHtml
DeleteModel = require('mixins/models/delete_model').DeleteModel
ClearModel = require('mixins/models/clear_model').ClearModel

class exports.Project extends Backbone.Model

  defaults:
    name: 'empty project...'
    done: false
    type: 'project'
    project_links_limit: 1
    tag_links_limit: 0
    project_links: []
    tag_links: []

# Add Mixins
exports.Project.prototype = _.extend exports.Project.prototype,
  ModelLinker, ToggleDoneness, GetHtml, DeleteModel, ClearModel
