(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    var AnnotationModel, _ref;

    return AnnotationModel = (function(_super) {
      __extends(AnnotationModel, _super);

      function AnnotationModel() {
        _ref = AnnotationModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      AnnotationModel.prototype.urlRoot = '/api/v1/annotations';

      AnnotationModel.prototype.paramRoot = 'annotation';

      AnnotationModel.prototype.urlRoot = '/api/v1/annotations';

      AnnotationModel.prototype.initialize = function() {
        this.visible = false;
        return this.locked = false;
      };

      AnnotationModel.prototype.setVisibility = function(visibility) {
        if (this.locked === false) {
          this.visible = visibility;
          return this.trigger('change:visibility');
        }
      };

      AnnotationModel.prototype.lockVisible = function() {
        this.locked = false;
        this.show();
        return this.locked = true;
      };

      AnnotationModel.prototype.unlock = function() {
        return this.locked = false;
      };

      AnnotationModel.prototype.show = function() {
        if (this.visible === false) {
          return this.setVisibility(true);
        }
      };

      AnnotationModel.prototype.hide = function() {
        if (this.visible === true) {
          return this.setVisibility(false);
        }
      };

      AnnotationModel.prototype.getTimestamp = function() {
        var fh, fm, fs, hours, minutes, seconds, totalMinutes, totalSeconds;

        totalSeconds = parseInt(this.get('seconds_timecode'));
        totalMinutes = Math.floor(totalSeconds / 60);
        hours = Math.floor(totalMinutes / 60);
        minutes = totalMinutes - (hours * 60);
        seconds = totalSeconds - (hours * 60 * 60) - (minutes * 60);
        fh = ("0" + hours).slice(-2);
        fm = ("0" + minutes).slice(-2);
        fs = ("0" + seconds).slice(-2);
        return "" + fh + ":" + fm + ":" + fs;
      };

      AnnotationModel.prototype.toJSON = function() {
        var attributes;

        attributes = _.clone(this.attributes);
        $.each(attributes, function(key, value) {
          if ((value != null) && _(value.toJSON).isFunction()) {
            return attributes[key] = value.toJSON();
          }
        });
        attributes.smpte_timecode = this.getTimestamp();
        return attributes;
      };

      return AnnotationModel;

    })(Backbone.Model);
  });

}).call(this);
