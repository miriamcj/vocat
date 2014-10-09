define (require) ->

  Marionette = require('marionette')
  ClosesOnUserAction = require('behaviors/closes_on_user_action')

  class DropdownView extends Marionette.ItemView

    adjusted: false

    triggers: {
      'click @ui.trigger': 'click:trigger'
    }

    ui: {
      trigger: '[data-behavior="toggle"]'
      dropdown: '[data-behavior="dropdown-options"]'
    }

    behaviors: {
      closesOnUserAction: {
        behaviorClass: ClosesOnUserAction
      }
    }

    onClickTrigger: () ->
      if @$el.hasClass('open')
        @close()
      else
        @open()

    adjustPosition: () ->
      if @adjusted == false
        dd = @$el.find('[data-behavior="dropdown-options"]')
        if dd.offset().left < 0
          dd.css({left: 0})
          dd.css({right: 'auto'})
        else if (dd.width() + dd.offset().left - $('html').width()) < 25
          dd.css({right: 0})
          dd.css({left: 'auto'})
        @adjusted = true

    open: () ->
      @$el.addClass('open')
      @adjustPosition()
      @triggerMethod('opened')

    close: () ->
      @$el.removeClass('open')
      @triggerMethod('closed')

    initialize: (options) ->
      @vent = options.vent
      if !@$el.hasClass('dropdown-initialized')
        @$el.addClass('dropdown-initialized')
