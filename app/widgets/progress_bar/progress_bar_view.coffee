ProgressBarTemplate = require 'widgets/progress_bar/progress_bar'
class exports.ProgressBarView extends Backbone.View

  render: ->
    @$el.html ProgressBarTemplate()
    @width(10)
    @

  width: (width) =>
    @$('.ui-progress').width(width + "%")
