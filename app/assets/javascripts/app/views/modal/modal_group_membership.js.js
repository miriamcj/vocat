define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/modal/modal_group_membership')
  GroupModel = require('models/group')

  class ModalGroupMembershipView extends Marionette.ItemView

    template: template

    triggers: {
      'click [data-behavior="dismiss"]': 'click:dismiss'
    }

    onKeyUp: (e) ->
      code = if e.keyCode? then e.keyCode else e.which
      if code == 27 then @onClickDismiss()


    onClickDismiss: () ->
      Vocat.vent.trigger('modal:close')

    onDestroy: () ->
      $(window).off('keyup', @onKeyUp)

    initialize: (options) ->
      _.bindAll(@, 'onKeyUp');
      $(window).on('keyup', @onKeyUp)
      groupId = options.groupId
      @model = new GroupModel({id: groupId})
      @model.fetch({
        success: () =>
          @render()
      })
