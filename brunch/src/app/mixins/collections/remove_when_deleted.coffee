exports.RemoveWhenDeleted =
  removeWhenDeleted: (model) ->
    if model.get('deleted')
      # Defer to ensure that the new "deleted" attribute can be saved before
      # removing the model from its collection. Without the defer, a url error
      # was thrown as the model was removed from its collection before it could
      # save its new state.
      _.defer =>
        @remove model
