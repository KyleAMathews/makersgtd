exports.DeleteModel =
  # Don't actually delete. Just flag as deleted.
  delete: ->
    @save deleted: true
    @view.close()

    # Delete any inbound links to this model.
    for links in [@get('context_links'), @get('action_links'), @get('project_links')]
      if links? and links.length > 0
        for link in links
          model = app.util.loadModelSynchronous(link.type, link.id)
          model.deleteLink(@type, @id)

  undelete: ->
    @save deleted: false
