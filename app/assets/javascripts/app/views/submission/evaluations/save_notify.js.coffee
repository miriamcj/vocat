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

    onClickEvaluationSave: () ->
      @model.save()
      Vocat.vent.trigger('error:add', {level: 'notice', lifetime: '3000',  msg: 'Your evaluation has been saved.'})
      @destroy()

    onClickEvaluationRevert: () ->
      @model.revert()
      Vocat.vent.trigger('error:add', {level: 'notice', lifetime: '3000',  msg: 'Your evaluation has been reverted to its saved state.'})
      @destroy()
