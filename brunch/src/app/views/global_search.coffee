Autocomplete = require('mixins/views/autocomplete').Autocomplete

class exports. GlobalSearch extends Backbone.View

  events:
    'keypress input'   : 'updateOnEnter'
    'keyup input'   : 'autocomplete'
    'keydown input'   : 'selectResult'
    'hover ul.autocomplete li' : 'hoverSelect'
    'click ul.autocomplete li' : 'navigate'

  initialize: ->
    $(document).keypress (e) => 
      if e.charCode is 47 and e.target.nodeName isnt 'TEXTAREA' and e.target.nodeName isnt 'INPUT'
        @$('input').focus()
        e.preventDefault()

  updateOnEnter: (e) ->
    @navigate() if e.keyCode is $.ui.keyCode.ENTER

  navigate: (e) ->
    url = @$('ul.autocomplete li.active').data('url')
    app.routers.main.navigate(url, true)
    @stopEditing()

  autocomplete: (e) =>
    # If the user is trying to navigate the results list, let the selectResult
    # method do its work.
    if _.indexOf([$.ui.keyCode.UP, $.ui.keyCode.DOWN], e.keyCode) isnt -1
      return

    @$('ul.autocomplete').empty().hide()
    @matches = []
    query = @$('input').val()
    switch query.substring(0,1)
      when '#' then @matches = fuzzymatcher.query 'projects', query.substring(1)
      when '@' then @matches = fuzzymatcher.query 'tags', query.substring(1)
      else @matches = fuzzymatcher.query 'all', query

    @grouped_matches = _.groupBy(@matches, (match) -> return match.type)
    order = ['tag', 'project', 'action']
    for type in order
      if @grouped_matches[type]?
        matches = @grouped_matches[type]
      else continue
      @$('ul.autocomplete').append('<h4>' + _.capitalize(type) + '</h4>')
      matches = _.sortBy(matches, (match) -> return match.match_score)
      matches = matches.slice(0,5)
      for match in matches
        model = app.util.getModel(match.type, match.id)
        @$('ul.autocomplete').append('<li data-url=' + model.iurl() + '>' + match.highlighted + '</li>')

    @$('ul.autocomplete li').first().addClass('active')
    if @matches.length > 0 then @$('ul.autocomplete').show()

  stopEditing: =>
    $('#global-search input').blur().val('')
    @$('ul.autocomplete').empty().hide()

# Add Mixins selectResult and hoverSelect
exports.GlobalSearch.prototype = _.extend exports.GlobalSearch.prototype,
  Autocomplete
