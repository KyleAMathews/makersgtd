exports.DeleteModel =
  # Don't actually delete. Just flag as deleted.
  delete: ->
    @save deleted: true
    @view.remove()
