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
      recentCourseSelect: '[data-class="recent-course-select"]'
    }

    toggle: () ->
      if @$el.hasClass('drawer-open')
        @close()
      else
        @open()

    open: () ->
      $("[data-drawer-target=\"#{@drawerTarget}\"]").addClass('drawer-open')
      @triggerMethod('opened')

    close: () ->
      $("[data-drawer-target=\"#{@drawerTarget}\"]").removeClass('drawer-open')
      @triggerMethod('closed')

    setupListeners: () ->
      @ui.courseSelect.on('change', () =>
        val = @ui.courseSelect.val()
        window.location.assign(val)
      )
      @ui.recentCourseSelect.on('change', () =>
        val = @ui.recentCourseSelect.val()
        window.location.assign(val)
      )

    setSpacing: () ->
      trigger = $("[data-drawer-target=\"#{@drawerTarget}\"][data-behavior=\"header-drawer-trigger\"]")
      if trigger.length > 0
        left = trigger.offset().left
        myLeft = @$el.find('.drawer--contents').offset().left
        @$el.find('.drawer--contents').css({paddingLeft: left - myLeft + 21})


    initialize: (options) ->
      @vent = options.vent
      @globalChannel = Backbone.Wreqr.radio.channel('global')
      @drawerTarget = @$el.data().drawerTarget
      @setSpacing()
      @listenTo(@globalChannel.vent, "drawer:#{@drawerTarget}:toggle", () =>
        @toggle()
      )
      @bindUIElements()

      options = {
        disable_search_threshold: 1000,
        allow_single_deselect: false,
        placeholder_text_single: 'Jump to a different course'
      }
      @ui.courseSelect.chosen(options)

      @setupListeners()