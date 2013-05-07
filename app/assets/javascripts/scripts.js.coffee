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

dropdown = {
  init: ->
    $toggle = $('[data-class=dropdown-toggle]')
    $dropdown = $('[data-class=dropdown]')
    $container = $('[data-class=dropdown-container]')
    $dropdown.each( ->
      containerHeight = $(@).parents('[data-class=dropdown-container]').outerHeight()
      $(@).css('top',containerHeight)
    )
    # $(document).click( ->
    #   $container.removeClass('open')
    # )
    # TODO click on toggle of closed menu should close any other open menu and open clicked menu
    $toggle.click((event) ->
      globalState = $container.hasClass('open')
      localState = $(@).parents('.open').length
      $(@).parents('[data-class=dropdown-container]').toggleClass('open')
      if globalState == false
        event.stopPropagation()
      event.preventDefault()
      # console.log globalState
      # console.log localState
    )
    # TODO this breaks logout link
    # $dropdown.click((event) ->
    #   event.stopPropagation()
    # )
}

pageHeader = {
  init: ->
    $('.js-page-header').waypoint((direction) ->
      if direction == "down"
        $(@).addClass('stuck')
      if direction == "up"
        $(@).removeClass('stuck')
    )
}

# TODO temporary
shortcutNav = {
  init: ->
    $('.js-shortcut-nav-toggle').click((event) ->
      $(@).toggleClass('active')
      $('.js-shortcut-nav').toggleClass('visible')
      event.preventDefault()
    )
}

# TODO needs to be aware of checkbox state before toggling active class
helpOverlay = {
  init: ->
    $('[data-behavior=help-overlay-toggle]').click( ->
      $(@).parents('label').toggleClass('active')
    )
}

$ ->
  dropdown.init()
  pageHeader.init()
  shortcutNav.init()
  helpOverlay.init()
