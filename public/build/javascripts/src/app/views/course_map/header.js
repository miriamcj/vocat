(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/course_map/header'], function(Marionette, template) {
    var CourseMapHeader, _ref;

    return CourseMapHeader = (function(_super) {
      __extends(CourseMapHeader, _super);

      function CourseMapHeader() {
        _ref = CourseMapHeader.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CourseMapHeader.prototype.template = template;

      CourseMapHeader.prototype.triggers = {
        'click [data-behavior="overlay-close"]': 'close'
      };

      CourseMapHeader.prototype.onClose = function() {
        return this.vent.triggerMethod('close:overlay');
      };

      CourseMapHeader.prototype.initialize = function(options) {
        var _this = this;

        this.options = options || {};
        this.vent = Marionette.getOption(this, 'vent');
        this.collections = Marionette.getOption(this, 'collections');
        this.listenTo(this.collections.creator, 'change:active', function() {
          return _this.render();
        });
        return this.listenTo(this.collections.project, 'change:active', function() {
          return _this.render();
        });
      };

      CourseMapHeader.prototype.serializeData = function() {
        var context;

        context = {};
        if (this.collections.creator.getActive() != null) {
          context.creator = this.collections.creator.getActive().toJSON();
        }
        if (this.collections.project.getActive() != null) {
          context.project = this.collections.project.getActive().toJSON();
        }
        return context;
      };

      return CourseMapHeader;

    })(Marionette.ItemView);
  });

}).call(this);
