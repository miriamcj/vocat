/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

export default AnnotationModel = (function() {
  AnnotationModel = class AnnotationModel extends Backbone.Model {
    static initClass() {

      this.prototype.urlRoot = '/api/v1/annotations';
      this.prototype.paramRoot = 'annotation';
    }

    initialize() {
      this.visible = false;
      return this.locked = false;
    }

    setVisibility(visibility) {
      if (this.locked === false) {
        this.visible = visibility;
        return this.trigger('change:visibility');
      }
    }

    lockVisible() {
      this.locked = false;
      this.show();
      return this.locked = true;
    }

    unlock() {
      return this.locked = false;
    }

    show() {
      if (this.visible === false) { return this.setVisibility(true); }
    }

    hide() {
      if (this.visible === true) { return this.setVisibility(false); }
    }

    hasDrawing() {
      const canvas = this.get('canvas');
      if (canvas != null) {
        const data = JSON.parse(canvas);
        return data.svg !== null;
      } else {
        return false;
      }
    }

    getCanvasJSON() {
      let json = null;
      const canvas = this.get('canvas');
      if (canvas != null) {
        const imgData = JSON.parse(canvas);
        ({ json } = imgData);
        return json;
      }
    }

    getSvg() {
      let svg = null;
      const canvas = this.get('canvas');
      if (canvas != null) {
        const imgData = JSON.parse(canvas);
        ({ svg } = imgData);
        return svg;
      }
    }

    getTimestamp() {
      const totalSeconds = parseInt(this.get('seconds_timecode'));
      const totalMinutes = Math.floor(totalSeconds / 60);
      const hours = Math.floor(totalMinutes / 60);
      const minutes = totalMinutes - (hours * 60);
      const seconds = totalSeconds - (hours * 60 * 60) - (minutes * 60);
      const fh = (`0${hours}`).slice(-2);
      const fm = (`0${minutes}`).slice(-2);
      const fs = (`0${seconds}`).slice(-2);
      return `${fh}:${fm}:${fs}`;
    }

    activate() {
      if (this.collection) {
        return this.collection.activateModel(this);
      }
    }

    toJSON() {
      const attributes = _.clone(this.attributes);
      $.each(attributes, function(key, value) {
        if ((value != null) && _(value.toJSON).isFunction()) {
          return attributes[key] = value.toJSON();
        }
      });
      attributes.smpte_timecode = this.getTimestamp();
      return attributes;
    }
  };
  AnnotationModel.initClass();
  return AnnotationModel;
})();