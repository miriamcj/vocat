(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/course_map/creators', 'views/course_map/creators_item'], function(Marionette, template, Item) {
    var CourseMapCreatorsView, _ref;

    return CourseMapCreatorsView = (function(_super) {
      __extends(CourseMapCreatorsView, _super);

      function CourseMapCreatorsView() {
        _ref = CourseMapCreatorsView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CourseMapCreatorsView.prototype.tagName = 'ul';

      CourseMapCreatorsView.prototype.template = template;

      CourseMapCreatorsView.prototype.itemView = Item;

      CourseMapCreatorsView.prototype.itemViewOptions = function() {
        return {
          courseId: this.options.courseId
        };
      };

      CourseMapCreatorsView.prototype.onItemviewActive = function(view) {
        return this.vent.triggerMethod('row:active', {
          creator: view.model.id
        });
      };

      CourseMapCreatorsView.prototype.onItemviewInactive = function(view) {
        return this.vent.triggerMethod('row:inactive', {
          creator: view.model.id
        });
      };

      CourseMapCreatorsView.prototype.onItemviewDetail = function(view) {
        return this.vent.triggerMethod('open:detail:creator', {
          creator: view.model.id
        });
      };

      CourseMapCreatorsView.prototype.addSpacer = function() {
        return this.$el.append('<li class="matrix--row-spacer"></li>');
      };

      CourseMapCreatorsView.prototype.initialize = function(options) {
        this.options = options || {};
        this.vent = Marionette.getOption(this, 'vent');
        return this.listenTo(this, 'render', this.addSpacer);
      };

      return CourseMapCreatorsView;

    })(Marionette.CollectionView);
  });

}).call(this);
