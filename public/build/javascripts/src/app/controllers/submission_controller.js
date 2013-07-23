(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'controllers/vocat_controller', 'views/submission/submission_layout', 'collections/submission_collection', 'collections/project_collection', 'collections/creator_collection'], function(Marionette, VocatController, SubmissionLayoutView, SubmissionCollection, ProjectCollection, CreatorCollection) {
    var SubmissionController, _ref;

    return SubmissionController = (function(_super) {
      __extends(SubmissionController, _super);

      function SubmissionController() {
        _ref = SubmissionController.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      SubmissionController.prototype.collections = {
        creator: new CreatorCollection({}),
        submission: new SubmissionCollection({}),
        project: new ProjectCollection({})
      };

      SubmissionController.prototype.helpDev = function() {
        return this.creatorProjectDetail(8, 67, 14);
      };

      SubmissionController.prototype.creatorProjectDetail = function(course, creator, project) {
        var submission;

        if (course == null) {
          course = null;
        }
        if (creator == null) {
          creator = null;
        }
        if (project == null) {
          project = null;
        }
        submission = new SubmissionLayoutView({
          courseId: course,
          collections: this.collections,
          creator: this.collections.creator.get(creator),
          project: this.collections.project.get(project),
          submission: this.collections.submission.get(submission)
        });
        return window.Vocat.main.show(submission);
      };

      return SubmissionController;

    })(VocatController);
  });

}).call(this);
