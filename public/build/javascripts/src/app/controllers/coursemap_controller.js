(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'controllers/vocat_controller', 'collections/creator_collection', 'collections/project_collection', 'collections/submission_collection', 'views/course_map/course_map_layout'], function(Marionette, VocatController, CreatorCollection, ProjectCollection, SubmissionCollection, CourseMap) {
    var CourseMapController, _ref;

    return CourseMapController = (function(_super) {
      __extends(CourseMapController, _super);

      function CourseMapController() {
        _ref = CourseMapController.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CourseMapController.prototype.collections = {
        creator: new CreatorCollection([], {}),
        project: new ProjectCollection([], {}),
        submission: new SubmissionCollection([], {})
      };

      CourseMapController.prototype.layoutInitialized = false;

      CourseMapController.prototype.initializeLayout = function(courseId) {
        this.collections.submission.courseId = courseId;
        if (this.layoutInitialized === false) {
          this.courseMap = new CourseMap({
            courseId: courseId,
            collections: this.collections
          });
          window.Vocat.main.show(this.courseMap);
          return this.layoutInitialized = true;
        }
      };

      CourseMapController.prototype.grid = function(courseId) {
        return this.initializeLayout(courseId);
      };

      CourseMapController.prototype.creatorDetail = function(courseId, creatorId) {
        this.initializeLayout(courseId);
        return this.courseMap.triggerMethod('open:detail:creator', {
          creator: creatorId
        });
      };

      CourseMapController.prototype.projectDetail = function(courseId, projectId) {
        this.initializeLayout(courseId);
        return this.courseMap.triggerMethod('open:detail:project', {
          project: projectId
        });
      };

      CourseMapController.prototype.creatorProjectDetail = function(courseId, creatorId, projectId) {
        this.initializeLayout(courseId);
        return this.courseMap.triggerMethod('open:detail:creator:project', {
          creator: creatorId,
          project: projectId
        });
      };

      return CourseMapController;

    })(VocatController);
  });

}).call(this);
