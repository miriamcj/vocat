define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/group/save_notify')
  GlobalNotification = require('behaviors/global_notification')

  class GroupsView extends Marionette.ItemView

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
      @destroy()

    onClickGroupsRevert: () ->
      @collection.each((group) ->
        group.revert()
      )
      @destroy()
