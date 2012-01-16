expandingArea = require('templates/expanding_area')

class exports.ExpandingAreaView extends Backbone.View

  render: =>
    context = {}
    for k,v of @options
      context[k] = v
    $(@el).html(expandingArea( context ))

    # Wait for the HTML to be inserted first.
    _.defer @makeAreaExpandable

  makeAreaExpandable: =>
    @$('textarea').expandingTextarea()

    # Enable extra CSS
    $(@el).addClass('active')
