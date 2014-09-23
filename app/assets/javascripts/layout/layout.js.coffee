define ['jquery_rails', './plugins', 'vendor/plugins/chosen'], ($) ->

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
        $('html').addClass('wf-inactive')
      $ ->

        # Set a minimum height for every page except course map.
        #  if !$('body').hasClass('course-map')
        #$('.container').css('min-height', $(window).innerHeight() - $('.page-header').height() - 35)

        $('[data-behavior="drawer-trigger"]').drawerTrigger()
        $('[data-behavior="dropdown"]').dropdownNavigation()


        $('[data-behavior="chosen"]').each((index, el) ->
          $el = $(el)
          msg = 'Select an Option'
          msg = 'Month' if $el.hasClass('month')
          msg = 'Year' if $el.hasClass('year')
          msg = 'Day' if $el.hasClass('day')
          options = {
            disable_search_threshold: 1000,
            allow_single_deselect: true,
            placeholder_text_single: msg
          }
          console.log options
          $el.chosen(options)
        )

        #$('[data-behavior="sticky-header"]').stickyHeader()
        #$('[data-behavior="shortcut-nav-toggle"]').shortcutNavigation()
        #$('[data-behavior="help-overlay-toggle"]').helpOverlay()





  }