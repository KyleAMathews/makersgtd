exports.Sortable =
  makeSortable: (context) ->
    @$(context).sortable(
      start: (event, ui) ->
        $(event.target).parent().addClass('sorting')
      stop: (event, ui) ->
        $(event.target).parent().parent().children().removeClass('sorting')
    )
    @$('ul').bind('sortupdate', @resetOrder)

  resetOrder: ->
    order = []
    window.projectel = @$el
    @$el.children('ul').find('> li > .model-list-item').each (index) ->
      order.push $(@).data('id')

    @collection.saveOrder(order)
