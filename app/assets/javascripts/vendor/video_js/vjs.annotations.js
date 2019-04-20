define(function(require) {

  const template = require('video_js/annotations.hbs');

  var VjsAnnotationsPlugin = function(options) {

    VjsAnnotationsPlugin = class VjsAnnotationsPlugin {

      constructor(options, player) {
        this.activationHandler = this.activationHandler.bind(this);
        this.player = player;
        this.$playerEl = $(player.el());
        this.options = options;
        this.vent = options.vent;
        this.collection = options.collection;
        this.container = $('<div class="vjs-annotation"></div');
        this.$playerEl.find('.vjs-control-bar').before(this.container);
        this.setupListeners();
      }

      activationHandler() {
        const annotation = this.collection.findWhere({active: true});
        return this.showAnnotation(annotation);
      }

      setupListeners() {
        this.collection.on('model:activated', this.activationHandler);

        this.player.on('fullscreenchange',event => {
          if (this.player.isFullscreen()) {
            return this.container.show();
          } else {
            return this.container.hide();
          }
        });

        return this.player.on('dispose', () => {
          return this.collection.off('model:activated', this.activationHandler);
        });
      }

      showAnnotation(annotation) {
        return this.container.html(template(annotation.toJSON()));
      }
    };

    return new VjsAnnotationsPlugin(options, this);
  };

  return videojs.plugin('annotations', VjsAnnotationsPlugin);
});
