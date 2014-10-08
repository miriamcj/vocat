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
          $el.chosen(options)
        )




  }