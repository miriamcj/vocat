define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/group/groups_item')
  ModalConfirmView = require('views/modal/modal_confirm')
  ShortTextInputView = require('views/property_editor/short_text_input')

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

    onClickEdit: () ->
      onSave = () =>
        # Tell the parent layout that its dirty and needs to save.
        @vent.triggerMethod('dirty')
      Vocat.vent.trigger('modal:open', new ShortTextInputView({model: @model, vent: @vent, onSave: onSave, property: 'name', inputLabel: 'What would you like to call this group?'}))

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
      @vent = options.vent
      @$el.attr('data-group', @model.id)

      @listenTo(@model, 'change:name', @render)
