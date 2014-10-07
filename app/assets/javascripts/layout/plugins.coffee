define ['vendor/plugins/waypoints', 'jquery_rails'], (waypoints, $) ->


  ##########################################
  # Sticky Header Plugin
  ##########################################
  $.fn.extend
    stickyHeader: (options) ->

      $el = $(@)

      if options == 'destroy'
        $el.waypoint('destroy')
        return $el
      else
        settings = {}
        settings = $.extend settings, options

        return @each ()->
          $el.waypoint((direction) ->
            if direction == "down"
              $el.addClass('stuck')
            if direction == "up"
              $el.removeClass('stuck')
          )

  ##########################################
  # Shortcut Navigation Plugin
  ##########################################
  $.fn.extend
    shortcutNavigation: (options) ->

      settings = {}
      settings = $.extend settings, options
      $nav = $('.js-shortcut-nav')
      setTimeout( () ->
          $nav.removeClass('invisible')
      , 500)

      return @each ()->
        $el = $(@)
        $el.click((event) ->
            $el.toggleClass('active')
            $nav.toggleClass('visible')
            event.preventDefault()
        )

  ##########################################
  # Help Overlay Plugin (may be refactored
  # into Backbone view)
  ##########################################
  $.fn.extend
    helpOverlay: (options) ->

      settings = {}
      settings = $.extend settings, options

      return @each ()->
        $toggle = $(@)
        state = $toggle.is(':checked')
        if state == true
          $toggle.parents('label').addClass('active')
        $toggle.click( ->
          $(@).parents('label').toggleClass('active')
        )
