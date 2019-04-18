/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/assets/player/image_displayer';
import PlayerAnnotations from 'views/assets/player/player_annotations';

export default ImageDisplayerView = (function() {
  ImageDisplayerView = class ImageDisplayerView extends Marionette.LayoutView {
    static initClass() {

      this.prototype.template = template;
      this.prototype.regions = {
        annotationsContainer: '[data-region="annotation-container"]'
      };

      this.prototype.ui = {
        annotationContainer: '[data-behavior="annotation-container"]'
      };
    }

    initialize(options) {
      return this.vent = options.vent;
    }

    onShow() {
      this.setupListeners();
      return this.annotationsContainer.show(new PlayerAnnotations({model: this.model, vent: this.vent}));
    }

    handleTimeUpdate(data) {
      if (data.hasOwnProperty('callback') && _.isFunction(data.callback)) {
        return data.callback.apply(data.scope);
      }
    }

    setupListeners() {
      this.listenTo(this.vent, 'request:status', data => this.handleStatusRequest());
      this.listenTo(this.vent, 'request:time:update', this.handleTimeUpdate, this);
      this.listenTo(this.vent, 'request:pause', data => this.handlePauseRequest());
      return this.listenTo(this.vent, 'announce:annotator:input:start', data => this.handlePauseRequest());
    }

    getStatus() {
      return {
      bufferedPercent: 0,
      playedPercent: 0,
      playedSeconds: 0,
      duration: 0
      };
    }

    handlePauseRequest() {
      return this.vent.trigger('announce:paused', this.getStatus());
    }

    handleStatusRequest() {
      return this.vent.trigger('announce:status', this.getStatus());
    }
  };
  ImageDisplayerView.initClass();
  return ImageDisplayerView;
})();

