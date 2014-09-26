define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/group/save_notify')

  class GroupsView extends Marionette.ItemView

    template: template

    triggers: {
      'click [data-trigger="save"]': 'click:groups:save'
      'click [data-trigger="revert"]': 'click:groups:revert'

    }

    onRender: () ->
      @$el.hide()

    onShow: () ->
      @$el.slideDown()

    remove: () ->
      @$el.slideUp(() =>
        @$el.remove()
      )

    onClickGroupsSave: () ->
      @collection.save()
      @destroy()

    onClickGroupsRevert: () ->
      @collection.each((group) ->
        group.revert()
      )
      @destroy()
