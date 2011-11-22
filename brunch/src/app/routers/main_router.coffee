ActionFullView = require('views/action_full_view').ActionFullView

class exports.MainRouter extends Backbone.Router
  routes :
    "home": "home"
    "actions/:id": "actionView"

  home: ->
    app.views.home.render()
    app.collections.actions.fetch()
    app.collections.projects.fetch()
    app.collections.tags.fetch()

  actionView: (id) ->
    app.views.home.render()
    action = app.collections.actions.get(id)
    if action?
      actionView = new ActionFullView model: action
      $('#simple-gtd-app').html actionView.render().el
