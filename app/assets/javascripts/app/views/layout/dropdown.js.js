define (require) ->
  Marionette = require('marionette')
  ClosesOnUserAction = require('behaviors/closes_on_user_action')

  class DropdownView extends Marionette.ItemView

    adjusted: false
    allowAdjustment: true
    originalBodyPadding: null


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
      dd = @$el.find('[data-behavior="dropdown-options"]')
      if @adjusted == false && @getOption('allowAdjustment') == true
        if dd.offset().left < 0
          dd.css({left: 0})
          dd.css({right: 'auto'})
        else if (dd.width() + dd.offset().left - $('html').width()) < 25
          dd.css({right: 0})
          dd.css({left: 'auto'})
        @adjusted = true

    checkBodyPadding: () ->
      dd = @$el.find('[data-behavior="dropdown-options"]')
      height = dd.outerHeight()
      requiredHeight = @$el.offset().top + height + @$el.outerHeight()
      documentHeight = $(document).height()
      if requiredHeight > documentHeight
        @originalBodyPadding = parseInt($('body').css('padding-bottom').replace('px',''))
        newPadding = parseInt(requiredHeight) - parseInt(documentHeight) + @originalBodyPadding + 60
        $('body').css({paddingBottom: newPadding})

    restoreBodyPadding: () ->
      if @originalBodyPadding != null
        $('body').css({paddingBottom: @originalBodyPadding})
        @originalBodyPadding = null

    open: () ->
      @checkBodyPadding()
      @$el.addClass('open')
      @adjustPosition()
      @triggerMethod('opened')

    close: () ->
      @$el.removeClass('open')
      @triggerMethod('closed')
      @restoreBodyPadding()

    initialize: (options) ->
      @vent = options.vent
      @$dropdown = @$el.find(@ui.dropdown)
      @$trigger = @$el.find(@ui.trigger)

      if !@$el.hasClass('dropdown-initialized')
        @$el.addClass('dropdown-initialized')
