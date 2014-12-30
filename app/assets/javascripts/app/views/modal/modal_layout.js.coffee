define [
  'marionette', 'hbs!templates/modal/modal_layout'
], (Marionette, template) ->

  class ModalLayout extends Marionette.LayoutView

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
      @closeModal()

    initialize: (options) ->
      @vent = Vocat.vent
      @$el.hide()

      @listenTo(@vent, 'modal:open', (view) =>
        @view = view
        @updateContent(view)
        @open()
      )

      @listenTo(@vent, 'modal:close', () =>
        @closeModal()
      )

    updateContent: (view) ->
      @content.show(view)

    closeModal: () ->
      @vent.trigger('modal:before:close')
      @content.reset()
      @ensureBackdrop().fadeOut(250)
      @$el.hide()
      @vent.trigger('modal:after:close')

    open: () ->
      @vent.trigger('modal:before:show')
      Backbone.Wreqr.radio.channel('global').vent.trigger('user:action')
      @showBackdrop()
      @centerModal()
      @$el.show()
      @vent.trigger('modal:after:show')
      @view.trigger('modal:after:show')

    centerModal: () ->
      @$el.prependTo('body')
      @$el.css({
        zIndex: 4000
        marginTop: '-150px'
        marginLeft: -1 * (@$el.find('[data-behavior=modal]').outerWidth() / 2) + 'px'
        position: 'fixed'
        left: '50%'
        top: '50%'
      })

    resizeBackdrop: () ->
      @ensureBackdrop().css({
        height: $(document).height()
        width: $(document).width()
      })

    ensureBackdrop: () ->
      backdrop = $('[data-behavior=modal-backdrop]')
      if backdrop.length == 0
        backdrop = $('<div class="modal-backdrop" data-behavior="modal-backdrop">').css({
          height: $(window).height()
        }).appendTo($('body')).hide()
        $(window).bind('resize', _.bind(@resizeBackdrop, @))
      backdrop

    showBackdrop: () ->
      @resizeBackdrop()
      @ensureBackdrop().fadeIn(150)
