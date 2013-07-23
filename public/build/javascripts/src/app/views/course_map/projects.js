(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'views/course_map/projects_item'], function(Marionette, Item) {
    var CourseMapProjectsView, _ref;

    return CourseMapProjectsView = (function(_super) {
      __extends(CourseMapProjectsView, _super);

      function CourseMapProjectsView() {
        _ref = CourseMapProjectsView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CourseMapProjectsView.prototype.itemView = Item;

      CourseMapProjectsView.prototype.className = 'matrix--column-header--list';

      CourseMapProjectsView.prototype.tagName = 'ul';

      CourseMapProjectsView.prototype.itemViewOptions = function() {
        return {
          courseId: this.options.courseId
        };
      };

      CourseMapProjectsView.prototype.onItemviewActive = function(view) {
        return this.vent.triggerMethod('col:active', {
          project: view.model.id
        });
      };

      CourseMapProjectsView.prototype.onItemviewInactive = function(view) {
        return this.vent.triggerMethod('col:inactive', {
          project: view.model.id
        });
      };

      CourseMapProjectsView.prototype.onItemviewDetail = function(view) {
        return this.vent.triggerMethod('open:detail:project', {
          project: view.model.id
        });
      };

      CourseMapProjectsView.prototype.initialize = function(options) {
        this.options = options || {};
        return this.vent = Marionette.getOption(this, 'vent');
      };

      return CourseMapProjectsView;

    })(Marionette.CollectionView);
  });

}).call(this);
