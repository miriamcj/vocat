define (require) ->

  marionette = require('marionette')
  template = require('hbs!templates/course/manage/projects/project_row')
  ModalConfirmView = require('views/modal/modal_confirm')

  class ProjectRowView extends Marionette.ItemView

    template: template
    tagName: 'tr'

    events: {
      "drop": "onDrop"
    }

    triggers: {
      'click [data-behavior="destroy"]': 'click:destroy'
    }

    onConfirmDestroy: () ->
      @model.destroy({
        success: () =>
          Vocat.vent.trigger('error:clear')
          Vocat.vent.trigger('error:add', {level: 'notice', lifetime: '5000',  msg: 'The project was successfully deleted.'})
        , error: () =>
          Vocat.vent.trigger('error:clear')
          Vocat.vent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors})
      })

    onClickDestroy: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        headerLabel: 'Are You Sure?'
        descriptionLabel: 'Deleting this project will also delete all of its associated submissions and evaluations. Are you sure you want to do this?',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }))

    onDrop: (e, i) ->
      @trigger("update-sort",[@model, i]);

    initialize: (options) ->
