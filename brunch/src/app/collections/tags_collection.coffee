Tag = require('models/tag_model').Tag

class exports.Tags extends Backbone.Collection

  model: Tag
  url: '/tags'

  initialize: ->
    console.log 'initing tag collection'

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

  comparator: (tag) ->
    tag.get 'order'
