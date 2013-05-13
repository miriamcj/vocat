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

# TODO remove redundancy
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
    $toggle.click((event) ->
      globalState = $container.hasClass('open')
      localState = $(@).parents().hasClass('open')
      if globalState == true
        $container.removeClass('open')
        event.stopPropagation()
      if localState == false
        event.stopPropagation()
      else
        $(@).parents('[data-class=dropdown-container]').toggleClass('open')
      $(@).parents('[data-class=dropdown-container]').toggleClass('open')
      event.preventDefault()
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

# TODO :checked state should be persistent across pageloads
helpOverlay = {
  init: ->
    $toggle = $('[data-behavior=help-overlay-toggle]')
    state = $toggle.is(':checked')
    if state == true
      $toggle.parents('label').addClass('active')
    $toggle.click( ->
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
    $('[data-behavior=matrix-creators]').waypoint((direction) ->
      if direction == "down" & $(@).hasClass('active')
        $(@).addClass('stuck')
      if direction == "up"
        $(@).removeClass('stuck')
    ,
      offset: 116
    )
    $('[data-behavior=matrix-creators]').find('a').click((event) ->
      listPositionAbsolute = $('[data-behavior=matrix-creators-list]').offset().top - $(window).scrollTop() - 266
      listPositionIncremental = Math.ceil(listPositionAbsolute / 68) * 68
      $('.matrix--content').hide()
      $('.matrix--overlay').show()
      $('[data-behavior=matrix-creators]').addClass('active')
      if listPositionIncremental <= 0
        $('[data-behavior=matrix-creators-list]').css('top',listPositionIncremental)
      window.scrollTo(top)
      event.preventDefault()
    )
    $('.close').click((event) ->
      $('.matrix--content').show()
      $('.matrix--overlay').hide()
      $('[data-behavior=matrix-creators]').removeClass('active')
      $('[data-behavior=matrix-creators-list]').css('top','0')
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
