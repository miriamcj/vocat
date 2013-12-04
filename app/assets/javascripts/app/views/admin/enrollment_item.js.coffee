define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment_item')

  class CreatorEnrollmentItem extends Marionette.ItemView

    template: template
    tagName: 'tr'

    triggers: () ->
      'click [data-behavior="destroy"]': 'clickDestroy'

    initialize: (options) ->
      @vent = options.vent

    onClickDestroy: () ->
      @model.destroy({
        wait: true
        success: (model) =>
          @vent.trigger('error:add', {level: 'notice', lifetime: 5000, msg: "#{model.get('name')} has been removed from the course."})
        error: (model, xhr) =>
          @vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: xhr.responseJSON.errors})
      })

    onRender: () ->
