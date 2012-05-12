Autocomplete = require('mixins/views/autocomplete').Autocomplete
globalSearchTemplate = require('templates/global_search')

class exports.GlobalSearch extends Backbone.View

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
      when '@' then @matches = fuzzymatcher.query 'contexts', query.substring(1)
      else @matches = fuzzymatcher.query 'all', query

    @grouped_matches = _.groupBy(@matches, (match) -> return match.type)
    order = ['context', 'project', 'action']
    for type in order
      if @grouped_matches[type]?
        matches = @grouped_matches[type]
      else continue
      @$('ul.autocomplete').append('<h4>' + _.capitalize(type) + '</h4>')
      matches = _.sortBy(matches, (match) -> return match.match_score)
      matches = matches.slice(0,5)
      ids = (match.id for match in matches)
      app.util.loadMultipleModels matches[0].type, ids, (models) ->
        for match in matches
          unless match.id? then match.id = match._id
          model = _.filter models, (model) -> return model.id is match.id
          model = model[0]
          # Get context and project names to add.
          contexts_info = []
          projects_info = []
          unless model? then continue
          unless model.type is 'context'
            contexts = model.get('context_links')
            projects = model.get('project_links')
            if projects?
              for project in projects
                project = app.util.loadModelSynchronous('project', project.id)
                if project
                  projects_info.push project.get('name')
            if contexts?
              for context in contexts
                context = app.util.loadModelSynchronous('context', context.id)
                if context
                  context_name = context.get('name')
                  context_colors = app.colorPalette[context.get('color_palette')]
                  contexts_info.push { name: context_name, colors: context_colors }

          classes = ""
          if model.get('done') then classes += "done "
          prefix = ""
          switch model.type
            when 'context' then prefix = "@"
            when 'project' then prefix = "#"
          @$('ul.autocomplete').append(globalSearchTemplate(
            model: model
            match: match
            contexts_info: contexts_info
            projects_info: projects_info
            classes: classes
            prefix: prefix
          ))

      @$('ul.autocomplete li').first().addClass('active')
      if @matches.length > 0 then @$('ul.autocomplete').show()

  stopEditing: =>
    $('#global-search input').blur().val('')
    @$('ul.autocomplete').empty().hide()

# Add Mixins Autocomplete
exports.GlobalSearch.prototype = _.extend exports.GlobalSearch.prototype,
  Autocomplete
