define (require) ->

  Marionette = require('marionette')

  class NotificationRegion extends Marionette.Region

    @PROMISE = $.Deferred().resolve()

    expiring: false

    attachHtml: (view) ->
      @$el.hide()
      @$el.empty().append(view.el)

    onEmpty: () ->
      @$el.remove()

    onShow: (view) ->
      timing = 250
      h = @$el.outerHeight()


      NotificationRegion.PROMISE = NotificationRegion.PROMISE.then(() =>
        @trigger('transition:start', h, timing)
        p = $.Deferred()
        @$el.fadeIn(timing, () =>
          p.resolve()
          @trigger('transition:complete', h, timing)
        )
        p
      )

      @listenTo(view, 'view:expired', () =>
        if @expiring == false
          @expiring = true
          NotificationRegion.PROMISE = NotificationRegion.PROMISE.then(() =>
            @trigger('transition:start', h * -1, timing)
            p = $.Deferred()
            @$el.fadeOut(timing, () =>
              p.resolve()
              @trigger('transition:complete', h * -1, timing)
              @trigger('region:expired')
            )
            p
          )
      )
