define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/group/save_notify')
  GlobalNotification = require('behaviors/global_notification')

  class SaveNotify extends Marionette.ItemView

    template: template

    triggers: {
      'click [data-trigger="save"]': 'click:groups:save'
      'click [data-trigger="revert"]': 'click:groups:revert'

    }

    behaviors: {
      globalNotification: {
        behaviorClass: GlobalNotification
      }
    }

    onClickGroupsSave: () ->
      @collection.save()
      Vocat.vent.trigger('notification:empty')
      Vocat.vent.trigger('error:add', {level: 'notice', lifetime: '3000', msg: 'Groups have been saved.'})

    onClickGroupsRevert: () ->
      @collection.each((group) ->
        group.revert()
      )
      Vocat.vent.trigger('notification:empty')
