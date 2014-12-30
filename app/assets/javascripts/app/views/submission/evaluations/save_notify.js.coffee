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
      Vocat.vent.trigger('notification:empty')
      @vent.triggerMethod('evaluation:save')

    onClickEvaluationRevert: () ->
      Vocat.vent.trigger('notification:empty')
      @vent.triggerMethod('evaluation:revert')
