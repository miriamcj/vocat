define (require) ->

  template = require('hbs!templates/group/group_warning')

  class GroupWarning extends Marionette.ItemView

    template: template

    triggers: {
      'click @ui.createGroup': 'click:group:add'
    }

    ui: {
      createGroup: '[data-behavior="create-group"]'
    }

    onClickGroupAdd: () ->
      @vent.triggerMethod('click:group:add')

    initialize: (options) ->
      @vent = options.vent

    serializeData: () ->
      {
        courseId: Marionette.getOption(@, 'courseId')
      }
