/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import VocatController from 'controllers/vocat_controller';
import CreatorDetailView from 'views/course_map/detail_creator';
import SubmissionLayoutView from 'views/submission/submission_layout';
import CourseUserSubmissionCollection from 'collections/submission_for_course_user_collection';
import GroupSubmissionCollection from 'collections/submission_for_group_collection';
import ProjectCollection from 'collections/project_collection';
import UserCollection from 'collections/user_collection';
import GroupCollection from 'collections/group_collection';
import AssetCollection from 'collections/asset_collection';
import AssetModel from 'models/asset';
import AssetDetail from 'views/assets/asset_detail';

export default class SubmissionController extends VocatController {
  constructor() {

    this.collections = {
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

