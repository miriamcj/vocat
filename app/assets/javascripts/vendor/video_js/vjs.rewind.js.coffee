define (require) ->


  VjsRewindPlugin = (options) ->

    class vjs.RewindComponent extends vjs.Button

      constructor: (player, @settings) ->
        super player, settings
        @player = player

      buildCSSClass: ->
        super + "vjs-rewind-button"

      onClick: ->
        super
        @player.currentTime(@player.currentTime() - 10)

    class VjsRewindPlugin

      constructor: (options, player) ->
        @player = player
        @player.controlBar.addChild(new vjs.RewindComponent(@player, options))

    return new VjsRewindPlugin(options, @)

  videojs.plugin('rewind', VjsRewindPlugin)