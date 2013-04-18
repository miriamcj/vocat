dropdown = {
  init: ->
    $toggle = $('[data-class=dropdown-toggle]')
    $dropdown = $('[data-class=dropdown]')
    $container = $('[data-class=dropdown-container]')
    $dropdown.each( ->
      containerHeight = $(@).parents('[data-class=dropdown-container]').outerHeight()
      $(@).css('top',containerHeight)
    )
    $(document).click( ->
      $container.removeClass('open')
    )
    # TODO click on toggle of closed menu should close any other open menu and open clicked menu
    $toggle.click((event) ->
      globalState = $container.hasClass('open')
      localState = $(@).parents('.open').length
      $(@).parents('[data-class=dropdown-container]').toggleClass('open')
      if globalState == false
        event.stopPropagation()
      event.preventDefault()

      console.log globalState
      console.log localState
    )
    $dropdown.click((event) ->
      event.stopPropagation()
    )

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

$ ->
  dropdown.init()
  pageHeader.init()
  shortcutNav.init()
