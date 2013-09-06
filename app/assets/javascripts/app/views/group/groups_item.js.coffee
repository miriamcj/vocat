define ['marionette', 'hbs!templates/group/groups_item', 'views/modal/modal_confirm', 'views/group/group_edit'], (Marionette, template, ModalConfirmView, GroupEditView) ->

  class GroupsItem extends Marionette.ItemView

    tagName: 'li'
    template: template
    attributes: {
      'data-behavior': 'navigate-group'
    }



    triggers: {
      'click [data-behavior="destroy"]': 'click:destroy'
      'click [data-behavior="edit"]': 'click:edit'
    }

    onShow: () ->
      console.log 'on show in item'

    onRender: () ->
      console.log 'on render in item'

    onClickEdit: () ->
      Vocat.vent.trigger('modal:open', new GroupEditView({model: @model, vent: @vent}))

    onConfirmDestroy: () ->
      @model.destroy({
        success: () =>
          Vocat.vent.trigger('error:clear')
          Vocat.vent.trigger('error:add', {level: 'notice', lifetime: '5000',  msg: 'group successfully deleted'})
      , error: () =>
          Vocat.vent.trigger('error:clear')
          Vocat.vent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors})
      })

    onClickDestroy: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleting this group will also delete any submissions and evaluations owned by this group. Are you sure you want to do this?',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }))

    serializeData: () ->
      data = super()
      data.courseId = @options.courseId
      data

    initialize: (options) ->
      messages = @options
      @$el.attr('data-group', @model.id)

      @listenTo(@model, 'change:name', @render)