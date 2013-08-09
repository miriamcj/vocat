define [
  'marionette', 'hbs!templates/modal/modal_layout'
], (Marionette, template) ->

  class ModalLayout extends Marionette.Layout

    template: template

    attributes: {
      style: 'display: none;'
    }

    triggers: {
      'click [data-behavior="modal-close"]': 'click:modal:close'
    }

    regions: {
      content: '[data-region="content"]'
    }

    onClickModalClose: () ->
      @close()

    initialize: (options) ->
      @vent = Vocat.vent
      @$el.hide()

      @listenTo(@vent, 'modal:open', (view) =>
        @updateContent(view)
        @open()
      )

      @listenTo(@vent, 'modal:close', () =>
        @close()
      )


    updateContent: (view) ->
      @content.show(view)

    close: () ->
      @vent.trigger('modal:before:close')
      @content.close()
      @ensureBackdrop().fadeOut(250)
      @$el.hide()
      @vent.trigger('modal:after:close')

    open: () ->
      @vent.trigger('modal:before:show')
      @showBackdrop()
      @centerModal()
      @$el.show()
      @vent.trigger('modal:after:show')

    centerModal: () ->
      yOffset = $(document).scrollTop()
      xOffset = $(document).scrollLeft()
      yCenter = $(window).height() / 2
      xCenter = $(window).width() / 2
      yPosition = yCenter - (@$el.find('.js-modal').outerHeight() / 2)
      xPosition = xCenter - (@$el.find('.js-modal').outerWidth() / 2)
      @$el.prependTo('body')
      @$el.css({
        position: 'absolute'
        zIndex: 300
        left: (xPosition + xOffset) + 'px'
        top: (yPosition + yOffset) + 'px'
      })

    resizeBackdrop: () ->
      @ensureBackdrop().css({
        height: $(document).height()
      })

    ensureBackdrop: () ->
      backdrop = $('#js-modal-backdrop')
      if backdrop.length == 0
        backdrop = $('<div id="js-modal-backdrop">').css({
          position: "absolute"
          top: 0
          left: 0
          height: $(document).height()
          width: "100%"
          opacity: 0.5
          backgroundColor: "#000"
          "z-index": 200
        }).appendTo($('body')).hide()
        $(window).bind('resize', _.bind(@resizeBackdrop, @))
      backdrop

    showBackdrop: () ->
      @resizeBackdrop()
      @ensureBackdrop().fadeIn(250)
