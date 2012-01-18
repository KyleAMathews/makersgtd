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

# Pane
Pane = require('mixins/pane').Pane

MainRouter = require('routers/main_router').MainRouter

# App bootstrapping on document ready
$(document).ready ->
  app.initialize = ->
    app.collections.actions = new Actions()
    app.collections.projects = new Projects()
    app.collections.tags = new Tags()

    app.pane0 = new Pane( el: '#simple-gtd-app .content' )

    app.routers.main = new MainRouter()

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
app.util.loadModelSynchronous = (type, id) ->
  unless id? and type? then return
  collection = type + "s"
  if app.collections[collection].get(id)?
    return app.collections[collection].get(id)
  else
    return false

app.util.loadModel = (type, id, callback) ->
  unless id? and type? and _.isFunction(callback) then return
  collection = type + "s"
  if app.collections[collection].get(id)?
    callbacks = {}
    callbacks[id] = callback
    app.util.loadMultipleModels(type, [id], callbacks)
  else if id.substr(0,1) is "c" and app.collections[collection].getByCid(id)?
    callback app.collections[collection].getByCid(id)
  # If the model isn't in the collection, create it and populate it from
  # the server. We trust that someone isn't trying to get a non-existant model.
  else
    # Proxy
    # At end of proxy, fetch each array of ids
    # when returned, loop through items and call callback with new model for each
    if not @items? then @items = []
    item =
      id: id
      callback: callback
      type: type
    @items.push item
    _.delay(app.util.flushProxy, 50, @items)

app.util.flushProxy = (items) =>
  types = _.groupBy items, (item) -> return item.type
  for type, items of types
    ids = []
    callbacks = {}
    for item in items
      ids.push item.id
      callbacks[item.id] = item.callback
    app.util.loadMultipleModels(type, ids, callbacks)

app.util.loadMultipleModels = (type, ids, callbacks) ->
  return if ids.length is 0
  models = []
  idsToFetch = []
  for id in ids
    if app.collections[type + 's'].get(id)?
      models.push app.collections[type + 's'].get(id)
    else
      idsToFetch.push id
  if idsToFetch.length is 0
    if _.isFunction(callbacks)
      callbacks(models)
    else
      for id, callback of callbacks
        callback app.collections[type + 's'].get(id)
  else
    app.collections[type + 's'].fetch
      add: true
      data:
        ids: idsToFetch
      success: (collection, response) =>
        if _.isFunction(callbacks)
          models = []
          for id in ids
            models.push collection.get(id)
          callbacks(models)
        for id, callback of callbacks
          callback collection.get(id)

app.util.modelFactory = (type) ->
  # TODO Figure out why after loading a model with project/tag links, each
  # model created there after has those same project/tag links??? Really strange.
  switch type
    when 'action' then return new Action()
    when 'project' then return new Project()
    when 'tag' then return new Tag()

app.util.makeExternalLinksOpenNewTab = (context) ->
  $("a[href^=http]", context).each ->
    if @href.indexOf(location.hostname) is -1
      $(@).attr
        target: "_blank",

app.util.shortenLongLinks = (context) ->
  $('a', context).each ->
    if $(@).text().length > 50
      $(@).text($(@).text().substring(0,50) + String.fromCharCode(8230)) # Ellipsis

app.util.ml = (model) ->
  return "<a href=" + model.iurl() + ">" + model.get('name') + "</a>"

app.util.toggleDonenessModel = (model) ->
  if typeof model.toggle is 'function'
    model.toggle()

app.util.deleteModel = (model) ->
  if typeof model.delete is 'function'
    model.delete()

app.util.undeleteModel = (model) ->
  if typeof model.undelete is 'function'
    model.undelete()

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

# BindTo facilitates the binding and unbinding of events
# from objects that extend `Backbone.Events`. It makes
# unbinding events, even with anonymous callback functions,
# easy.
#
# Thanks to Johnny Oshika for this code.
# http://stackoverflow.com/questions/7567404/backbone-js-repopulate-or-recreate-the-view/7607853#7607853
BindTo =
  # Store the event binding in array so it can be unbound
  # easily, at a later point in time.
  bindTo: (obj, eventName, callback, context) ->
    context = context || @
    obj.bind(eventName, callback, context)

    if !@bindings then @bindings = []

    @bindings.push({
      obj: obj,
      eventName: eventName,
      callback: callback,
      context: context
    })

  # Unbind all of the events that we have stored.
  unbindAll: ->
    _.each(@bindings, (binding) ->
      binding.obj.unbind(binding.eventName, binding.callback)
    )

    this.bindings = []

_.extend(Backbone.Model.prototype, BindTo)
_.extend(Backbone.View.prototype, BindTo)
_.extend(Backbone.Collection.prototype, BindTo)

# Add close method to views that unbinds all views, removes it from the DOM
# and closes each of its children views.
Backbone.View.prototype.close = ->
  @unbind()
  @unbindAll()
  @remove()

  if @children
    _.each @children, (childView) ->
      childView.close()

  if @onClose then @onClose()

# Add logChildView method so we can keep track of children views so when closing the
# parent view, it's easy to close each child view.
Backbone.View.prototype.logChildView = (childView) ->
  if !@children then @children = []
  @children.push childView
