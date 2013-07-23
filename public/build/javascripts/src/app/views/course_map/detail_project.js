(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/course_map/detail_project'], function(Marionette, template) {
    var CourseMapDetailCreator, _ref;

    return CourseMapDetailCreator = (function(_super) {
      __extends(CourseMapDetailCreator, _super);

      function CourseMapDetailCreator() {
        _ref = CourseMapDetailCreator.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CourseMapDetailCreator.prototype.template = template;

      CourseMapDetailCreator.prototype.itemViewContainer = '[data-container="submission-summaries"]';

      CourseMapDetailCreator.prototype.initialize = function(options) {
        var collections;

        this.options = options || {};
        this.vent = Marionette.getOption(this, 'vent');
        this.courseId = Marionette.getOption(this, 'courseId');
        this.projectId = Marionette.getOption(this, 'projectId');
        collections = Marionette.getOption(this, 'collections');
        this.projects = collections.project;
        this.creators = collections.creator;
        return this.project = this.projects.get(this.projectId);
      };

      return CourseMapDetailCreator;

    })(Marionette.CompositeView);
  });

}).call(this);
