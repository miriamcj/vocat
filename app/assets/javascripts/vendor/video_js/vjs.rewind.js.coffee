define (require) ->


  VjsRewindPlugin = (options) ->

    class videojs.RewindComponent extends videojs.getComponent('Button')

      constructor: (player, settings) ->
        super player, settings
        @player = player

      buildCSSClass: ->
        super + "vjs-rewind-button"

      handleClick: ->
        super
        @player.currentTime(@player.currentTime() - 10)

    class VjsRewindPlugin

      constructor: (options, player) ->
        @player = player
        @player.controlBar.addChild(new videojs.RewindComponent(@player, options))

    return new VjsRewindPlugin(options, @)

  videojs.plugin('rewind', VjsRewindPlugin)