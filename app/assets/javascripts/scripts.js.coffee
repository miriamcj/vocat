dropdown = {
  init: ->
    $toggle = $('[data-class=dropdown-toggle]')
    $dropdown = $('[data-class=dropdown]')
    $dropdown.each( ->
      containerHeight = $(@).parents('[data-class=dropdown-container]').outerHeight()
      $(@).css('top',containerHeight)
    )
    $toggle.click((event) ->
      $(@).parents('[data-class=dropdown-container]').toggleClass('open')
      event.preventDefault()
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