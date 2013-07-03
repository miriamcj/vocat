define ['jquery', './plugins'], ($) ->

  {
    bootstrap: () ->
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

      $ ->
        $('[data-behavior="dropdown"]').dropdownNavigation()
        $('[data-behavior="sticky-header"]').stickyHeader()
        $('[data-behavior="shortcut-nav-toggle"]').shortcutNavigation()
        $('[data-behavior="help-overlay-toggle"]').helpOverlay()

        # Set a minimum height for every page except course map.
        #  if !$('body').hasClass('course-map')
        $('.container').css('min-height', $(window).innerHeight() - $('.page-header').height() - 35)
  }