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
      yPosition = yCenter - (@$el.find('[data-behavior=modal]').outerHeight() / 2)
      xPosition = xCenter - (@$el.find('[data-behavior=modal]').outerWidth() / 2)
      @$el.prependTo('body')
      @$el.css({
        position: 'absolute'
        left: (xPosition + xOffset) + 'px'
        top: (yPosition + yOffset) + 'px'
      })

    resizeBackdrop: () ->
      @ensureBackdrop().css({
        height: $(document).height()
      })

    ensureBackdrop: () ->
      backdrop = $('[data-behavior=modal-backdrop]')
      if backdrop.length == 0
        backdrop = $('<div class="modal-backdrop" data-behavior="modal-backdrop">').css({
          height: $(document).height()
        }).appendTo($('body')).hide()
        $(window).bind('resize', _.bind(@resizeBackdrop, @))
      backdrop

    showBackdrop: () ->
      @resizeBackdrop()
      @ensureBackdrop().fadeIn(250)
