(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/annotations_item'], function(Marionette, template) {
    var AnnotationItem, _ref;

    return AnnotationItem = (function(_super) {
      __extends(AnnotationItem, _super);

      function AnnotationItem() {
        _ref = AnnotationItem.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      AnnotationItem.prototype.visible = true;

      AnnotationItem.prototype.template = template;

      AnnotationItem.prototype.tagName = 'li';

      AnnotationItem.prototype.className = 'annotations--item';

      AnnotationItem.prototype.triggers = {
        'click [data-behavior="destroy"]': 'destroy',
        'click [data-behavior="seek"]': 'seek'
      };

      AnnotationItem.prototype.initialize = function(options) {
        var _this = this;

        this.vent = options.vent;
        this.errorVent = options.errorVent;
        return this.listenTo(this.vent, 'player:time', function(data) {
          if (_this.model.get('seconds_timecode') <= data.seconds) {
            if (_this.visible === false) {
              _this.visible = true;
              _this.$el.fadeIn();
              return _this.vent.triggerMethod('item:shown');
            }
          } else {
            if (_this.visible === true) {
              _this.visible = false;
              _this.$el.fadeOut();
              return _this.vent.triggerMethod('item:hidden');
            }
          }
        });
      };

      AnnotationItem.prototype.onBeforeRender = function() {
        this.$el.hide();
        return this.visible = false;
      };

      AnnotationItem.prototype.onSeek = function() {
        return this.vent.triggerMethod('player:seek', {
          seconds: this.model.get('seconds_timecode')
        });
      };

      AnnotationItem.prototype.onDestroy = function() {
        var _this = this;

        return this.model.destroy({
          success: function() {
            _this.errorVent.trigger('error:clear');
            return _this.errorVent.trigger('error:add', {
              level: 'notice',
              lifetime: '5000',
              msg: 'annotation successfully deleted'
            });
          },
          error: function() {
            _this.errorVent.trigger('error:clear');
            return _this.errorVent.trigger('error:add', {
              level: 'notice',
              msg: xhr.responseJSON.errors
            });
          }
        });
      };

      return AnnotationItem;

    })(Marionette.ItemView);
  });

}).call(this);
