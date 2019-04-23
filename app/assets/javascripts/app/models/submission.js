/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import { findWhere } from "lodash";
import VideoModel from 'models/video';
import EvaluationModel from 'models/evaluation';
import ProjectModel from 'models/project';
import UserModel from 'models/user';
import GroupModel from 'models/group';
import AssetCollection from 'collections/asset_collection';

export default class SubmissionModel extends Backbone.Model {
  constructor() {

    this.assetCollection = null;
  }

  urlRoot() {
    return '/api/v1/submissions';
  }

  updateUrl() {
    return `${this.urlRoot()}/${this.id}`;
  }

  requestTranscoding() {}

  destroyVideo() {
    return this.video.destroy({
      success: () => {
        this.set('video', null);
        return this.fetch({url: this.updateUrl()});
      }
    });
  }

  toJSON() {
    const json = super.toJSON();
    if (this.video) {
      json.video = this.video.toJSON();
    } else {
      json.video = null;
    }
    return json;
  }

  getVideoId() {
    if ((this.video != null) && (this.video.id != null)) {
      return this.video.id;
    } else {
      return null;
    }
  }

  updateVideo() {
    const rawVideo = this.get('video');
    if (rawVideo != null) {
      return this.video = new VideoModel(rawVideo);
    }
  }

  hasVideo() {
    return (this.get('video') != null);
  }

  publishEvaluation() {
    this.set('current_user_published', true);
    const evaluationData = findWhere(this.get('evaluations'), {current_user_is_evaluator: true});
    const evaluation = new EvaluationModel(evaluationData);
    return evaluation.save({published: true});
  }

  unpublishEvaluation() {
    this.set('current_user_published', false);
    const evaluationData = findWhere(this.get('evaluations'), {current_user_is_evaluator: true});
    const evaluation = new EvaluationModel(evaluationData);
    return evaluation.save({published: false});
  }

  unsetMyEvaluation() {
    this.set('current_user_has_evaluated', true);
    this.set('current_user_percentage', 0);
    return this.set('current_user_evaluation_published', false);
  }

  toggleEvaluationPublish() {
    const promise = $.Deferred();
    promise.then(() => {
      if (this.get('current_user_published') === true) {
        return this.unpublishEvaluation();
      } else if (this.get('current_user_published') === false) {
        return this.publishEvaluation();
      }
    });
    return this.fetch({
      success: () => {
        return promise.resolve();
      }
    });
  }

  assets() {
    return this.assetCollection;
  }

  detailUrl(courseId) {
    let creatorTypeSegment;
    if (courseId == null) { courseId = false; }
    if (!courseId) {
      const p = this.get('project');
      courseId = p.course_id;
    }
    const ct = this.get('creator_type');
    if (ct === 'User') {
      creatorTypeSegment = 'users';
    } else {
      creatorTypeSegment = 'groups';
    }
    const cid = this.get('creator_id');
    const pid = this.get('project_id');
    const url = `/courses/${courseId}/${creatorTypeSegment}/evaluations/creator/${cid}/project/${pid}`;
    return url;
  }

  project() {
    if ((this.projectModel == null)) {
      this.projectModel = new ProjectModel(this.get('project'));
    }
    return this.projectModel;
  }

  creator() {
    if ((this.creatorModel == null)) {
      if (this.get('creator_type') === 'User') {
        this.creatorModel = new UserModel(this.get('creator'));
      } else if (this.get('creator_type') === 'Group') {
        this.creatorModel = new GroupModel(this.get('creator'));
      } else {
        this.creatorModel = null;
      }
    }
    return this.creatorModel;
  }

  initialize() {
    this.listenTo(this, 'change:video', () => {
      return this.updateVideo();
    });
    this.updateVideo();

    this.listenTo(this, 'sync change', () => {
      return this.updateAssetsCollection();
    });
    return this.updateAssetsCollection();
  }

  updateAssetsCollection() {
    if (!this.assetCollection) {
      return this.assetCollection = new AssetCollection(this.get('assets'), {submissionId: this.id});
    } else {
      return this.assetCollection.reset(this.get('assets'));
    }
  }
}
