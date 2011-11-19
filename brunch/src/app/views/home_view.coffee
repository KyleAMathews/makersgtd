homeTemplate = require('templates/home')

class exports.HomeView extends Backbone.View
  el: '#home-view'

  render: ->
    $(@el).html homeTemplate()
    $(@el).find('#simple-gtd-app').append app.views.newAction.render().el
    $(@el).find('#simple-gtd-app').append app.views.actions.render().el
    @
