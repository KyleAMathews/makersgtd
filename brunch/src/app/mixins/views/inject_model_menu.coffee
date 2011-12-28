exports.InjectModelMenu =
  injectModelMenu: (e) ->
    if e.currentTarget.checked
      app.models.contextMenu.add(@model)
    else
      app.models.contextMenu.remove(@model)
