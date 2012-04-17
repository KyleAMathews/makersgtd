actionTemplate = require('templates/action_full')
editableView = require('views/editable_view').EditableView
linkerView = require('views/linker_view').LinkerView
MetaInfoView = require('views/meta_info').MetaInfoView
DropdownMenuView = require('views/dropdown_menu_view').DropdownMenuView

class exports.ActionFullView extends Backbone.View

  id: 'action'
  className: 'full-view'

  initialize: ->
    @bindTo(@model, 'change:done', @render)
    @model.view = @

  render: =>
    json = @model.toJSON()
    @$el.html(actionTemplate(
      action: json
    ))
    @logChildView editableName = new editableView(
      field: 'name'
      el: @$el.find('.editable-name')
      model: @model
      options: ['save-on-enter']
      blank_slate_text: 'Add Name'
    )
    if @model.get('done') then editableName.options.options.push 'done'
    editableName.render()
    @logChildView new editableView(
      field: 'description'
      el: @$el.find('.editable-note')
      model: @model
      blank_slate_text: 'Add Notes'
      lines: 3
      label: 'Notes'
      html: true
    ).render()
    @logChildView new linkerView(
      el: @$el.find('.linker-project')
      model: @model
      blank_slate: 'Add to project'
      linking_to: 'project'
      intro: 'in project '
      prefix: '#'
      models: @model.get('projects')
    ).render()
    @logChildView new linkerView(
      el: @$el.find('.linker-context')
      model: @model
      blank_slate: 'Add a context'
      linking_to: 'context'
      intro: 'contexts '
      prefix: '@'
      models: @model.get('contexts')
    ).render()
    @logChildView new DropdownMenuView(
      el: @$el.find('.dropdown')
      model: @model
    ).render()
    @logChildView new MetaInfoView(
      el: @$el.find('.meta-info')
      model: @model
    ).render()
    @
