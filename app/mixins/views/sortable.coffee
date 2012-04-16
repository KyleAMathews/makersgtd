exports.Sortable =
  makeSortable: (context) ->
    @$(context).sortable()
    @$('ul').bind('sortupdate', @resetOrder)

  resetOrder: ->
    order = []
    window.projectel = @$el
    @$el.children('ul').find('> li > .model-list-item').each (index) ->
      order.push $(@).data('id')

    @collection.saveOrder(order)
