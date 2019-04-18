/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let CourseMapController;
const VocatController = require('controllers/vocat_controller');
const UserCollection = require('collections/user_collection');
const ProjectCollection = require('collections/project_collection');
const SubmissionForCourseCollection = require('collections/submission_for_course_collection');
const GroupSubmissionCollection = require('collections/submission_for_group_collection');
const CourseUserSubmissionCollection = require('collections/submission_for_course_user_collection');
const GroupCollection = require('collections/group_collection');
const AssetCollection = require('collections/asset_collection');
const AssetDetail = require('views/assets/asset_detail');
const CourseMap = require('views/course_map/course_map');
const SubmissionDetail = require('views/submission/submission_layout');
const CreatorDetail = require('views/course_map/detail_creator');
const ProjectDetail = require('views/project/detail');
const ApplicationErrorView = require('views/error/application_error');
const AssetModel = require('models/asset');

export default CourseMapController = (function() {
  CourseMapController = class CourseMapController extends VocatController {
    static initClass() {

      this.prototype.collections = {
        user: new UserCollection([], {}),
        group: new GroupCollection([], {}),
        project: new ProjectCollection([], {}),
        submission: new SubmissionForCourseCollection([], {}),
        asset: new AssetCollection([], {})
      };

      this.prototype.layoutInitialized = false;
      this.prototype.submissionsSynced = false;
    }

    initialize() {
      return this.bootstrapCollections();
    }

    userCourseMap(courseId) {
      this._loadSubmissions(courseId);
      const courseMap = new CourseMap({creatorType: 'User', courseId, collections: this.collections});
      return window.Vocat.main.show(courseMap);
    }

    groupCourseMap(courseId) {
      this._loadSubmissions(courseId);
      const courseMap = new CourseMap({creatorType: 'Group', courseId, collections: this.collections});
      return window.Vocat.main.show(courseMap);
    }

    groupProjectDetail(courseId, projectId) {
      return this._showProjectDetail(projectId, 'Group');
    }

    userProjectDetail(courseId, projectId) {
      return this._showProjectDetail(projectId, 'User');
    }

    groupSubmissionDetail(courseId, creatorId, projectId) {
      return this._showSubmissionDetail('Group', courseId, creatorId, projectId);
    }

    groupSubmissionDetailAsset(courseId, creatorId, projectId, assetId) {
      return this._showSubmissionDetail('Group', courseId, creatorId, projectId, assetId);
    }

    userSubmissionDetail(courseId, creatorId, projectId) {
      return this._showSubmissionDetail('User', courseId, creatorId, projectId);
    }

    userSubmissionDetailAsset(courseId, creatorId, projectId, assetId) {
      return this._showSubmissionDetail('User', courseId, creatorId, projectId, assetId);
    }

    userCreatorDetail(courseId, creatorId) {
      return this._showCreatorDetail('User', courseId, creatorId);
    }

    groupCreatorDetail(courseId, creatorId) {
      return this._showCreatorDetail('Group', courseId, creatorId);
    }

    standaloneUserProjectDetail(courseId, projectId) {}
      //TODO: Move standalone details into this controller

    assetDetail(courseId, assetId) {
      return this._loadAsset(assetId).done(asset => {
        const assetDetail = new AssetDetail({
          courseId,
          model: asset,
          context: 'coursemap'
        });
        return window.Vocat.main.show(assetDetail);
      });
    }

    _loadAsset(assetId) {
      const deferred = $.Deferred();
      const asset = new AssetModel({id: assetId});
      asset.fetch({
        success() {
          return deferred.resolve(asset);
        }
      });
      return deferred;
    }

    _loadSubmissions(courseId) {
      if (this.submissionsSynced === false) {
        return this.collections.submission.fetch({
          reset: true,
          data: {course: courseId},
          error: () => {
            return Vocat.vent.trigger('modal:open', new ModalErrorView({
              model: this.model,
              vent: this,
              message: 'Exception: Unable to fetch collection models. Please report this error to your VOCAT administrator.',
            }));
          },
          success: () => {
            return this.submissionsSynced = true;
          }
        });
      }
    }

    _loadOneSubmission(creatorType, creatorId, projectId) {
      const deferred = $.Deferred();

      deferred.fail(this._handleSubmissionLoadError);

      // We don't deal in submission IDs in VOCAT (although I kind if wish we had), so we're fetching this
      // model outside of the usual collection/model framework. At some point, we may want to move this fetching
      // logic into a JS factory class or the submission model itself.
      $.ajax({
        url: "/api/v1/submissions/for_creator_and_project",
        method: 'get',
        data: {
          creator: creatorId,
          project: projectId,
          creator_type: creatorType
        },
        success: data => {
          if (data.length > 0) {
            const raw = _.find(data, s =>
              // It's possible to get two submissions back for an open project, so we need to grab the correct one.
              (parseInt(s.creator.id) === parseInt(creatorId)) && (s.creator_type === creatorType)
            );
            const { id } = raw;
            this.collections.submission.add(raw, {merge: true});
            const submission = this.collections.submission.get(id);
            return deferred.resolve(submission);
          } else {
            return deferred.reject(creatorType, creatorId, projectId, null);
          }
        },
        error: response => {
          let status = null;
          if ((response != null) && ((response.status != null) != null)) {
            ({ status } = response);
          }
          return deferred.reject(creatorType, creatorId, projectId, status);
        }
      });
      return deferred;
    }

    _handleSubmissionLoadError(creatorType, creatorId, projectId, status) {
      let statusMsg;
      if (status) {
        statusMsg = `When Vocat tried to load this submission, the server replied with a ${status} error.`;
      } else {
        statusMsg = "When Vocat tried to load this submission, the server did not return a valid submission.";
      }
      return window.Vocat.main.show(new ApplicationErrorView({
        errorDetails: {
          description: `${statusMsg} This means that the submission data is likely corrupted and needs to be repaired. \
This error has been logged and reported to the vocat development team.`,
          code: `SUBMISSION-LOAD-FAILURE: CT${creatorType}UID${creatorId}PID${projectId}`
        }
      }));
    }

    _showSubmissionDetail(creatorType, courseId, creatorId, projectId, assetId = null, courseMapContext) {
      if (courseMapContext == null) { courseMapContext = true; }
      const deferred = this._loadOneSubmission(creatorType, creatorId, projectId);
      return deferred.done(submission => {
        const submissionDetail = new SubmissionDetail({
          collections: {submission: this.collections.submission},
          courseId,
          creator: creatorId,
          project: projectId,
          model: submission,
          initialAsset: assetId,
          courseMapContext
        });
        return window.Vocat.main.show(submissionDetail);
      });
    }


    _showCreatorDetail(creatorType, courseId, creatorId, courseMapContext) {
      let collection, model;
      if (courseMapContext == null) { courseMapContext = true; }
      if (creatorType === 'User') {
        model = this.collections.user.get(creatorId);
        collection = new CourseUserSubmissionCollection();
      } else if (creatorType === 'Group') {
        model = this.collections.group.get(creatorId);
        collection = new GroupSubmissionCollection();
      }
      const creatorDetail = new CreatorDetail({
        collection,
        courseId,
        model,
        courseMapContext
      });
      return window.Vocat.main.show(creatorDetail);
    }

    _showProjectDetail(projectId, creatorType, courseMapContext) {
      if (courseMapContext == null) { courseMapContext = true; }
      const model = this.collections.project.get(projectId);
      const projectDetail = new ProjectDetail({
        model,
        creatorType,
        courseMapContext
      });
      return window.Vocat.main.show(projectDetail);
    }
  };
  CourseMapController.initClass();
  return CourseMapController;
})();
