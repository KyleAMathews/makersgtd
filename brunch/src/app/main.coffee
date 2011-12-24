window.app = {}
app.routers = {}
app.models = {}
app.collections = {}
app.views = {}

require('jquery_plugins')

# Collections
Actions = require('collections/actions_collection').Actions
Projects = require('collections/projects_collection').Projects
Tags = require('collections/tags_collection').Tags

# Models
Action = require('models/action_model').Action
Project = require('models/project_model').Project
Tag = require('models/tag_model').Tag

# Views
GlobalSearch = require('views/global_search').GlobalSearch

# Context Menu
ContextMenu = require('views/context_menu').ContextMenu
ContextMenuModel = require('models/context_menu_model').ContextMenuModel

MainRouter = require('routers/main_router').MainRouter

# App bootstrapping on document ready
$(document).ready ->
  app.initialize = ->
    app.collections.actions = new Actions()
    app.collections.projects = new Projects()
    app.collections.tags = new Tags()

    app.models.contextMenu = new ContextMenuModel()

    app.routers.main = new MainRouter()

    app.views.contextMenu = new ContextMenu(
      el: $('.context-menu')
      model: app.models.contextMenu
    )
    app.views.contextMenu.render()

    new GlobalSearch(
      el: $('#global-search')
    )
    $('#global-search input').val('')

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
  unless id? and type? then return
  collection = type + "s"
  if app.collections[collection].get(id)?
    return app.collections[collection].get(id)
  else if id.substr(0,1) is "c" and app.collections[collection].getByCid(id)?
    return app.collections[collection].getByCid(id)
  # If the model isn't in the collection, create it and populate it from
  # the server. We trust that someone isn't trying to get a non-existant model.
  else
    newModel = app.util.modelFactory(type)
    newModel.id = id
    app.collections[collection].add(newModel, { silent: true })
    newModel.fetch()
    return newModel

app.util.modelFactory = (type) ->
  switch type
    when 'action' then return new Action()
    when 'project' then return new Project()
    when 'tag' then return new Tag()

app.util.makeExternalLinksOpenNewTab = (context) ->
  $("a[href^=http]", context).each ->
    if @href.indexOf(location.hostname) is -1
      $(@).attr
        target: "_blank",

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

# Extend the Backbone model prototype to add an internal url generator.
Backbone.Model.prototype.iurl = ->
  return '#' + @get('type') + 's/' + @id

# Mixin capitalize function to underscore.
_.mixin(
  capitalize : (string) ->
    return string.charAt(0).toUpperCase() + string.substring(1).toLowerCase();
)

keyNav = []
# Crude global navigation
$(document).keypress (e) ->
  if e.target.nodeName is 'TEXTAREA' or e.target.nodeName is 'INPUT'
    return
  if keyNav.length is 0
    switch e.charCode
      when 103
        keyNav.push 'g'
        return

  if keyNav.length is 1
    switch e.charCode
      when 110 then keyNav.push 'n'
      when 112 then keyNav.push 'p'
      when 116 then keyNav.push 't'
      else keyNav = []

  if keyNav.length is 2
    switch keyNav.toString()
      when 'g,n'
        app.routers.main.navigate '#next-actions', true
        keyNav = []
      when 'g,p'
        app.routers.main.navigate '#projects', true
        keyNav = []
      when 'g,t'
        app.routers.main.navigate '#tags', true
        keyNav = []
      else keyNav = []
