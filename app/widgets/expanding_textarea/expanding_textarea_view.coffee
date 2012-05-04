$ = jQuery
expandingTextarea = require('widgets/expanding_textarea/expanding_textarea')

class exports.ExpandingTextareaView extends Backbone.View

  render: =>
    context = {}
    for k,v of @options
      context[k] = v
    @$el.html(expandingTextarea( context ))

    @makeAreaExpandable context.lines
    @

  makeAreaExpandable: (lines) =>
    # Set minimum number of lines.
    if not lines? then lines = 1
    fontSize = parseInt(@$('textarea').css('font-size').slice(0,-2), 10)
    paddingTop = parseInt(@$('textarea').css('padding-top').slice(0,-2), 10)
    paddingBottom = parseInt(@$('textarea').css('padding-bottom').slice(0,-2), 10)
    # Mozilla bug - https://bugzilla.mozilla.org/show_bug.cgi?id=308801
    # min-height doesn't work right for box-sizing:border-box
    if $.browser.mozilla
      height = lines * 1.5
    else
      height = (lines * 1.5) + (paddingTop + paddingBottom) / fontSize # Num ems for padding.

    height = height + "em"

    # Set widget to active.
    @$el.addClass('active')

    _.defer =>
      @$('textarea').expandingTextarea()
      @$('.textareaClone').css({ 'min-height': height })
