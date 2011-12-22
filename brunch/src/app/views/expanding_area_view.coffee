expandingArea = require('templates/expanding_area')

class exports.ExpandingAreaView extends Backbone.View

  render: =>
    $(@el).html(expandingArea( edit_text: @options.edit_text ))

    # Wait for the HTML to be inserted first.
    _.defer @makeAreaExpandable

  makeAreaExpandable: =>
    container = $(@el)
    area = container.find('textarea')
    span = container.find('span')
    area.on 'input', ->
      span.text(area.val())
    span.text(area.val())

    # Enable extra CSS
    container.addClass('active')
