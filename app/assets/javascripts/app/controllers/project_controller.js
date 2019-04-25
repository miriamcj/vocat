/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import VocatController from 'controllers/vocat_controller';
import UserCollection from 'collections/user_collection';
import ProjectCollection from 'collections/project_collection';
import ProjectDetail from 'views/project/detail';
import ApplicationErrorView from 'views/error/application_error';

export default class ProjectController extends VocatController.extend({
  collections: {
    user: new UserCollection([], {}),
    project: new ProjectCollection([], {})
  },

  layoutInitialized: false,
  submissionsSynced: false
}) {
  initialize() {
    return this.bootstrapCollections();
  }

  groupProjectDetail(courseId, projectId) {
    return this._showProjectDetail(projectId, 'Group');
  }

  userProjectDetail(courseId, projectId) {
    return this._showProjectDetail(projectId, 'User');
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