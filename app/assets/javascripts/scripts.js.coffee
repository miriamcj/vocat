# Typekit font events
try
  Typekit.load(
    active: ->
      # Vertically centers alert labels
      $('[data-behavior=alert]').each( ->
        alertHeight = $(@).outerHeight()
        alertTop = (alertHeight / 2) - 14;
        $(@).children('[data-behavior=alert-label]').css('top',alertTop)
      )
  )
catch e

# Reference jQuery
$ = jQuery

##########################################
# Dropdown Navigation Plugin
##########################################
$.fn.extend
  dropdownNavigation: (options) ->
    settings = {}
    settings = $.extend settings, options

    return @each ()->
      $container= $(@)
      $toggle = $container.find('[data-behavior="toggle"]')
      $(document).click( ->
        $container.removeClass('open')
      )
      $toggle.click( (event) ->
        event.preventDefault()
        if $container.hasClass('open')
          $container.removeClass('open')
          event.stopPropagation()
        else
          $container.addClass('open')
          event.stopPropagation()
      )

##########################################
# Sticky Header Plugin
##########################################\
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

    return @each ()->
      $el = $(@)
      $el.click((event) ->
          $el.toggleClass('active')
          $('.js-shortcut-nav').toggleClass('visible')
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

$ ->

  $('[data-behavior="dropdown"]').dropdownNavigation()
  $('[data-behavior="sticky-header"]').stickyHeader()
  $('[data-behavior="shortcut-nav-toggle"]').shortcutNavigation()
  $('[data-behavior="help-overlay-toggle"]').helpOverlay()

  # Set a minimum height for every page except course map.
#  if !$('body').hasClass('course-map')
  $('.container').css('min-height', $(window).innerHeight() - $('.page-header').height() - 35)
