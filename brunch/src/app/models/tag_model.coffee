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

# Add Mixins
exports.Tag.prototype = _.extend exports.Tag.prototype,
  ModelLinker, GetHtml, DeleteModel, ClearModel
