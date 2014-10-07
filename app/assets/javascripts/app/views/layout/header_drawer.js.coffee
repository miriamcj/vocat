define (require) ->

  Marionette = require('marionette')

  class HeaderDrawerView extends Marionette.ItemView

    toggle: () ->
      if $('body').hasClass('drawer-open')
        @close()
      else
        @open()

    open: () ->
      $('body').addClass('drawer-open')
      @globalChannel.vent.trigger('user:action')
      @listenTo(@globalChannel.vent, 'user:action', (event) =>
        unless event && $.contains(@el, event.target)
         console.log 'closing'
         @close()
      )

    close: () ->
      $('body').removeClass('drawer-open')
      @stopListening(@globalChannel.vent, 'user:action')

    initialize: (options) ->
      @vent = options.vent
      @globalChannel = Backbone.Wreqr.radio.channel('global')
      @listenTo(@globalChannel.vent, 'drawer:toggle', () =>
        @toggle()
      )


#
###########################################
## Drawer Navigation Plugin
###########################################
#$.fn.extend
#  drawerTrigger: (options) ->
#    $trigger = $(@)
#    $body = $('body')
#    $drawer = $('.page-header--drawer')
#    $nav = $('.drawer--contents ul:first-child')
#    $shield = ''
#
#    setup = () ->
##        $nav.find('ul').hide()
##        $nav.children('li').click((e) ->
##          $nav.find('ul').hide()
##          $(@).children('ul').show()
##        )
#
#    open = () ->
#      $shield = $('<div class="page-shield"></div>')
#      $shield.height($('body').height())
#      $body.prepend($shield)
#      $body.addClass('drawer-open')
#      $shield.show()
#
#    close = () ->
#      $body.removeClass('drawer-open')
#      if $shield?
#        $shield.detach()
#
#    handleClick = () ->
#      if $body.hasClass('drawer-open')
#        close()
#      else
#        open()
#
#    $trigger.click( (event) ->
#      event.stopPropagation()
#      handleClick()
#    )
#
#    $drawer.click( (event) ->
#      event.stopPropagation()
#    )
#
#    #      $(document).click ->
#    #        if $body.hasClass('drawer-open')
#    #          close()
#
#    setup()