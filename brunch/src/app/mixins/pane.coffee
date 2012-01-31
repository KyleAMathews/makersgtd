# Code partially borrowed from https://github.com/derickbailey/backbone.marionette
class exports.Pane

  constructor: (options) ->
    @options = options || (options = {})
    if !@options.el
      throw new Error("An 'el' must be specified")
    @$el = $(@options.el)

  # Displays a backbone view instance inside of the region.
  # Handles calling the `render` method for you. Reads content
  # directly from the `el` attribute. Also calls an optional
  # `onShow` and `close` method on your view, just after showing
  # or just before closing the view, respectively.
  show: (view) ->
    oldView = @currentView
    @currentView = view

    @_closeView oldView
    @_openView view

  _closeView: (view) ->
    if view && view.close
      view.close()

  _openView: (view) ->
    @$el.html view.render().el
    if view.onShow
      view.onShow()
