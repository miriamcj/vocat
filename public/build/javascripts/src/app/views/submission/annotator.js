(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/annotator', 'models/annotation'], function(Marionette, template, AnnotationModel) {
    var AnnotatorView, _ref;

    return AnnotatorView = (function(_super) {
      __extends(AnnotatorView, _super);

      function AnnotatorView() {
        _ref = AnnotatorView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      AnnotatorView.prototype.template = template;

      AnnotatorView.prototype.ui = {
        input: '[data-behavior="annotation-input"]'
      };

      AnnotatorView.prototype.events = {
        'keypress :input': 'onEventKeypress'
      };

      AnnotatorView.prototype.triggers = {
        'submit': 'submit'
      };

      AnnotatorView.prototype.initialize = function(options) {
        this.vent = Marionette.getOption(this, 'vent');
        return this.courseId = Marionette.getOption(this, 'courseId');
      };

      AnnotatorView.prototype.onEventKeypress = function(e) {
        return this.vent.triggerMethod('player:stop', {});
      };

      AnnotatorView.prototype.onSubmit = function() {
        var _this = this;

        this.listenToOnce(this.vent, 'player:broadcast:response', function(response) {
          var annotation, seconds_timecode;

          seconds_timecode = response.currentTime.toFixed(2);
          annotation = new AnnotationModel({
            attachment_id: _this.model.attachment.id,
            body: _this.ui.input.val(),
            published: false,
            seconds_timecode: seconds_timecode
          });
          return annotation.save({}, {
            success: function(annotation) {
              _this.collection.add(annotation);
              _this.vent.trigger('error:clear');
              _this.vent.trigger('error:add', {
                level: 'notice',
                lifetime: 3000,
                msg: 'annotation successfully added'
              });
              _this.render();
              return _this.vent.triggerMethod('player:start', {});
            },
            error: function(annotation, xhr) {
              _this.vent.trigger('error:clear');
              return _this.vent.trigger('error:add', {
                level: 'error',
                msg: xhr.responseJSON.errors
              });
            }
          });
        });
        return this.vent.triggerMethod('player:broadcast:request', {});
      };

      return AnnotatorView;

    })(Marionette.ItemView);
  });

}).call(this);
