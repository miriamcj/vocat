define (require) ->

  Marionette = require('marionette')

  class NotificationRegion extends Marionette.Region

    attachHtml: (view) ->
      @$el.hide()
      @$el.empty().append(view.el)

    onEmpty: () ->
      @$el.remove()

    onShow: (view) ->
      @$el.slideDown(200, () =>
        @trigger('fade:complete')
      )
      @listenTo(view, 'view:expired', () ->
        @$el.slideUp(200, () =>
          @trigger('fade:complete')
          @trigger('region:expired')
        )
      )
