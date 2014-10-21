define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/save_notify')
  GlobalNotification = require('behaviors/global_notification')

  class GroupsView extends Marionette.ItemView

    template: template

    triggers: {
      'click [data-trigger="save"]': 'click:evaluation:save'
      'click [data-trigger="revert"]': 'click:evaluation:revert'
    }

    behaviors: {
      globalNotification: {
        behaviorClass: GlobalNotification
      }
    }

    initialize: (options) ->
      @vent = options.vent

    onClickEvaluationSave: () ->
      @vent.triggerMethod('evaluation:save')
      @destroy()

    onClickEvaluationRevert: () ->
      @vent.triggerMethod('evaluation:revert')
      @destroy()
