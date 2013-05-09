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

stickyHeaders = {
  init: ->
    $('[data-behavior=sticky-header]').waypoint((direction) ->
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

matrixSlider = {
  init: ->
    $firstSlider = $('[data-behavior=matrix-slider]').first()
    $leftButton = $('[data-behavior=matrix-slider-left]')
    $rightButton = $('[data-behavior=matrix-slider-right]')
    sliderWidth = $firstSlider.outerWidth(true)
    itemCount = $firstSlider.find('li').length
    itemWidth = $firstSlider.find('li').first().outerWidth()
    listWidth = itemCount * itemWidth;
    $('[data-behavior=matrix-slider] ul').each( ->
      $(@).width(listWidth)
    )
    left = 0
    $leftButton.click((event) ->
      if left != 0
        left += 205
        $('[data-behavior=matrix-slider] ul').css('left', left)
        $rightButton.removeClass('inactive')
        if left == 0
          $(@).addClass('inactive')
      event.preventDefault()
    )
    $rightButton.click((event) ->
      if listWidth + left > sliderWidth
        left -= 205
        $('[data-behavior=matrix-slider] ul').css('left', left)
        $leftButton.removeClass('inactive')
        if listWidth + left <= sliderWidth
          $(@).addClass('inactive')
      event.preventDefault()
    )
}

# TODO janky & temporary
matrixOverlay = {
  init: ->
    $('[data-behavior=matrix-row-header] a').click((event) ->
      $('.matrix--content').hide()
      $('.matrix--overlay').show()
      event.preventDefault()
    )
    $('.close').click((event) ->
      $('.matrix--content').show()
      $('.matrix--overlay').hide()
      event.preventDefault()
    )
}

$ ->
  dropdown.init()
  stickyHeaders.init()
  shortcutNav.init()
  helpOverlay.init()
  matrixSlider.init()
  matrixOverlay.init()
