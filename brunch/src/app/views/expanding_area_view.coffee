expandingArea = require('templates/expanding_area')

class exports.ExpandingAreaView extends Backbone.View

  render: =>
    context = {}
    for k,v of @options
      context[k] = v
    @$el.html(expandingArea( context ))

    # Wait for the HTML to be inserted first.
    _.defer @makeAreaExpandable, context.lines
    @

  makeAreaExpandable: (lines) =>
    @$('textarea').expandingTextarea()

    # Set minimum number of lines.
    if not lines? then lines = 1
    height = (lines * 1.5) + 20/13 # each line is 1.5em + 20/13 for the padding (20px / 13px base height).
    height = height + "em"
    @$('textarea').css({ 'min-height': height })
    @$('.textareaClone').css({ 'min-height': height })

    # Set widget to active.
    @$el.addClass('active')
