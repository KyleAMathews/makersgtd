Action = require('models/action_model').Action

class exports.Actions extends Backbone.Collection

  model: Action
  url: '/actions'

  initialize: ->
    @localStorage = new Store "actions"

  done: ->
    return @filter( (action) ->
      action.get 'done'
    )

  remaining: ->
    @without.apply @, @done()

  nextOrder: ->
    return 1 unless @length
    @last().get('order') + 1

  initCursor: =>
    @cursor = 0
    # Reset all model's cursor setting to false.
    @each (action) ->
      action.set ( cursorOn: false )

    @at(@cursor).set( cursorOn: true )

  cursorDown: =>
    # Add one to the cursor and return unless we're at the end of the collection.
    unless @cursor >= (@length - 1)
      # Turn cursor off at old place.
      @at(@cursor).set( cursorOn: false )
      @cursor += 1
      # Turn cursor on at new place.
      @at(@cursor).set( cursorOn: true )
      return @cursor
    # If at the end, just return the current value.
    return @cursor

  cursorUp: =>
    # Subtract one from the cursor and return unless we're at the beginning of the collection.
    unless @cursor is 0
      # Turn cursor off at old place.
      @at(@cursor).set( cursorOn: false )
      @cursor -= 1
      # Turn cursor on at new place.
      @at(@cursor).set( cursorOn: true )
      return @cursor
    # If at the end, just return the current value.
    return @cursor

  checkAtCursor: =>
    @getActionAtCursor().toggle()

  openAtCursor: =>
     app.routers.main.navigate "actions/" + @getActionAtCursor().id, true

  getActionAtCursor: =>
    actions = @filter (action) ->
      return action.get "cursorOn"
    return actions[0]

  comparator: (action) ->
    action.get 'order'

  clearCompleted: ->
    _.each(@done(), (action) ->
      action.clear()
    )
