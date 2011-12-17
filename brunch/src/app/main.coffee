window.app = {}
app.routers = {}
app.models = {}
app.collections = {}
app.views = {}

require('jquery_plugins')

Actions = require('collections/actions_collection').Actions
Projects = require('collections/projects_collection').Projects
Tags = require('collections/tags_collection').Tags

MainRouter = require('routers/main_router').MainRouter

# App bootstrapping on document ready
$(document).ready ->
  app.initialize = ->
    app.collections.actions = new Actions()
    app.collections.projects = new Projects()
    app.collections.tags = new Tags()

    app.routers.main = new MainRouter()

    # GET models from server.
    # Don't initialize router until all the collection fetches have returned.
    successCounter = ->
      counter = 0
      return {
        add: ->
          counter += 1
          if counter is 3
            app.routers.main.navigate 'next-actions', true if Backbone.history.getFragment() is ''
            Backbone.history.start()
      }
    counter = successCounter()

    app.collections.actions.fetch success: => counter.add()
    app.collections.projects.fetch success: => counter.add()
    app.collections.tags.fetch success: => counter.add()

  app.initialize()

window.markdown = new Markdown.Converter()

app.util = {}
app.util.getModel = (type, id) ->
  type = type + "s"
  return app.collections[type].get(id)

#represent character bindings as tree, once enter in tree, don't exit until reach leaf.
# Allow for global states, e.g. normal, input (don't do anything), a model is checked, etc
# global states in stack. Normal is always active. If model is active, it can choose
# which keys to override. If it doesn't override something, then things fallback
# to the next stack.

#if next keystroke doesn't match something, exit and start over again.

#e.g.
#     _i - call function navigateInbox
#   _|
#g |_
#    |_n - call function navigateNextActions
