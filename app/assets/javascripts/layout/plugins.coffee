define ['vendor/plugins/waypoints', 'jquery_rails'], (waypoints, $) ->



  ##########################################
  # Drawer Navigation Plugin
  ##########################################
  $.fn.extend
    drawerTrigger: (options) ->
      $trigger = $(@)
      $body = $('body')
      $drawer = $('.page-header--drawer')
      $nav = $('.drawer--contents ul:first-child')
      $shield = ''

      setup = () ->
        $nav.find('ul').hide()
        $nav.children('li').click((e) ->
          $nav.find('ul').hide()
          $(@).children('ul').show()
        )

      open = () ->
        $shield = $('<div class="page-shield"></div>')
        $shield.height($('body').height())
        $body.prepend($shield)
        $body.addClass('drawer-open')
        $shield.show()

      close = () ->
        $body.removeClass('drawer-open')
        if $shield?
          $shield.detach()

      handleClick = () ->
        if $body.hasClass('drawer-open')
          close()
        else
          open()

      $trigger.click( (event) ->
        event.stopPropagation()
        handleClick()
      )

      $drawer.click( (event) ->
        event.stopPropagation()
      )

#      $(document).click ->
#        if $body.hasClass('drawer-open')
#          close()

      setup()


  ##########################################
  # Dropdown Navigation Plugin
  ##########################################
  $.fn.extend
    dropdownNavigation: (options) ->
      settings = {}
      settings = $.extend settings, options

      dropdowns = []

      return @each ()->
        $container= $(@)
        dropdowns.push $container
        if !$container.hasClass('dropdown-initialized')
          $container.addClass('dropdown-initialized')
          $toggle = $container.find('[data-behavior="toggle"]')

          $toggle.css({cursor: 'pointer'})
          $(document).click( ->
            $container.removeClass('open')
          )
          $toggle.click( (event) ->
            $.each dropdowns, (index, dropdown) ->
              if dropdown != $container && dropdown.hasClass('open')
                dropdown.removeClass('open')
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
