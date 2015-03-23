define (require) ->

  template = require('hbs!vendor/video_js/annotations')

  VjsAnnotationsPlugin = (options) ->

    class VjsAnnotationsPlugin

      constructor: (options, player) ->
        @player = player
        @$playerEl = $(player.el())
        @options = options
        @vent = options.vent
        @collection = options.collection
        @container = $('<div class="vjs-annotation"></div')
        @$playerEl.find('.vjs-control-bar').before(@container)
        @setupListeners()

      activationHandler: () =>
        annotation = @collection.findWhere({active: true})
        @showAnnotation(annotation)

      setupListeners: () ->
        @collection.on('model:activated', @activationHandler)

        @player.on('fullscreenchange',(event) =>
          if @player.isFullscreen()
            @container.show()
          else
            @container.hide()
        )

        @player.on('dispose', () =>
          @collection.off('model:activated', @activationHandler)
        )

      showAnnotation: (annotation) ->
        @container.html(template(annotation.toJSON()))

    return new VjsAnnotationsPlugin(options, @)

  videojs.plugin('annotations', VjsAnnotationsPlugin)