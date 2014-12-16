define (require) ->

  Marionette = require('marionette')
  ClosesOnUserAction = require('behaviors/closes_on_user_action')

  class HeaderDrawerView extends Marionette.ItemView

    visibleCourses: 5
    filtered: false

    behaviors: {
      closesOnUserAction: {
        behaviorClass: ClosesOnUserAction
      }
    }

    ui: {
      courseSelect: '[data-class="course-select"]'
    }


    toggle: () ->
      if $('body').hasClass('drawer-open')
        @close()
      else
        @open()

    open: () ->
      $('body').addClass('drawer-open')
      @triggerMethod('opened')

    close: () ->
      $('body').removeClass('drawer-open')
      @triggerMethod('closed')

    setupListeners: () ->
      @ui.courseSelect.on('change',() =>
        val = @ui.courseSelect.val()
        window.location.assign(val)
      )

    initialize: (options) ->
      @vent = options.vent
      @globalChannel = Backbone.Wreqr.radio.channel('global')

      @listenTo(@globalChannel.vent, 'drawer:toggle', () =>
        @toggle()
      )
      @bindUIElements()
      @setupListeners()