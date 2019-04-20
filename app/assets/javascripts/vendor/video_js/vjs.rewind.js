define(function(require) {

  var VjsRewindPlugin = function(options) {

    videojs.RewindComponent = class RewindComponent extends videojs.getComponent('Button') {

      constructor(player, settings) {
        super(player, settings);
        this.player = player;
      }

      buildCSSClass() {
        return super.buildCSSClass(...arguments) + "vjs-rewind-button";
      }

      handleClick() {
        super.handleClick(...arguments);
        return this.player.currentTime(this.player.currentTime() - 10);
      }
    };

    VjsRewindPlugin = class VjsRewindPlugin {

      constructor(options, player) {
        this.player = player;
        this.player.controlBar.addChild(new videojs.RewindComponent(this.player, options));
      }
    };

    return new VjsRewindPlugin(options, this);
  };

  return videojs.plugin('rewind', VjsRewindPlugin);
});
