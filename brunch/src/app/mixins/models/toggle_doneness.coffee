exports.ToggleDoneness =
  toggle: ->
    if @get 'done'
      @save({
        done: false
        completed: ""
      }, { silent: true })
      @unset('completed')
      @trigger("change:done")
    else
      @save({
        done: true
        completed: new Date().toISOString()
      }, { silent: true })
      @trigger("change:done")
