exports.ToggleDoneness =
  toggle: ->
    if @get 'done'
      @save({
        done: false
        completed: ""
      }, { silent: true })
      @unset('completed')
      @trigger("change:done")
      @trigger("change")
    else
      @save({
        done: true
        completed: new Date().toISOString()
      }, { silent: true })
      @trigger("change:done")
      @trigger("change")
