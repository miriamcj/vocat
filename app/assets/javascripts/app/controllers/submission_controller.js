/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let SubmissionController;
  const Marionette = require('marionette');
  const VocatController = require('controllers/vocat_controller');
  const CreatorDetailView = require('views/course_map/detail_creator');
  const SubmissionLayoutView = require('views/submission/submission_layout');
  const CourseUserSubmissionCollection = require('collections/submission_for_course_user_collection');
  const GroupSubmissionCollection = require('collections/submission_for_group_collection');
  const ProjectCollection = require('collections/project_collection');
  const UserCollection = require('collections/user_collection');
  const GroupCollection = require('collections/group_collection');
  const AssetCollection = require('collections/asset_collection');
  const AssetModel= require('models/asset');
  const AssetDetail = require('views/assets/asset_detail');

  return SubmissionController = (function() {
    SubmissionController = class SubmissionController extends VocatController {
      static initClass() {
  
        this.prototype.collections = {
          user: new UserCollection({}),
          group: new GroupCollection({}, {courseId: null}),
          project: new ProjectCollection({}),
          asset: new AssetCollection({})
        };
      }

      creatorDetail(course, creator) {
        const userModel = this.collections.user.first();
        const view = new CreatorDetailView({
          courseId: course,
          model: userModel,
          collection: new CourseUserSubmissionCollection(),
          standalone: true
        });
        return window.Vocat.main.show(view);
      }

      groupDetail(course, creator) {
        const groupModel = this.collections.group.first();
        const view = new CreatorDetailView({
          courseId: course,
          model: groupModel,
          collection: new GroupSubmissionCollection(),
          standalone: true
        });
        return window.Vocat.main.show(view);
      }

      creatorProjectDetail(course, creator, project) {
        const userModel = this.collections.user.first();
        const projectModel = this.collections.project.first();
        const collection = new CourseUserSubmissionCollection();
        const deferred = this.deferredCollectionFetching(collection, {course, user: creator, project},
          'Loading submission...');
        return $.when(deferred).then(() => {
          const submissionModel = collection.findWhere({
            creator_type: 'User',
            creator_id: parseInt(creator),
            project_id: parseInt(project)
          });
          const view = new SubmissionLayoutView({
            courseId: course,
            creator: userModel,
            model: submissionModel,
            project: projectModel,
            courseMapContext: false
          });

          return window.Vocat.main.show(view);
        });
      }

      groupProjectDetail(course, creator, project) {
        const groupModel = this.collections.group.first();
        const projectModel = this.collections.project.first();
        const collection = new GroupSubmissionCollection();
        const deferred = this.deferredCollectionFetching(collection, {course, group: creator}, 'Loading submission...');
        return $.when(deferred).then(() => {
          const submissionModel = collection.findWhere({
            creator_type: 'Group',
            creator_id: parseInt(creator),
            project_id: parseInt(project)
          });
          const view = new SubmissionLayoutView({
            courseId: course,
            creator: groupModel,
            model: submissionModel,
            project: projectModel,
            courseMapContext: false
          });

          return window.Vocat.main.show(view);
        });
      }

      assetDetail(courseId, assetId) {
        return this._loadAsset(assetId).done(asset => {
          const assetDetail = new AssetDetail({
            courseId,
            model: asset,
            context: 'submission'
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
    };
    SubmissionController.initClass();
    return SubmissionController;
  })();
});

