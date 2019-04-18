/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ProjectController;
const VocatController = require('controllers/vocat_controller');
const UserCollection = require('collections/user_collection');
const ProjectCollection = require('collections/project_collection');
const ProjectDetail = require('views/project/detail');
const ApplicationErrorView = require('views/error/application_error');

export default ProjectController = (function() {
  ProjectController = class ProjectController extends VocatController {
    static initClass() {

      this.prototype.collections = {
        user: new UserCollection([], {}),
        project: new ProjectCollection([], {})
      };

      this.prototype.layoutInitialized = false;
      this.prototype.submissionsSynced = false;
    }

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
  ProjectController.initClass();
  return ProjectController;
})();