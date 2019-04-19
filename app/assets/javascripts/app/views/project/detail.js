/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';
import template from 'templates/project/detail.hbs';
import ProjectScoreOverviewView from 'views/project/detail/project_score_overview';
import ProjectSubmissionListView from 'views/project/detail/project_submission_list';
import ProjectStatisticsModel from 'models/project_statistics';
import SubmissionCollection from 'collections/submission_for_project_collection';
import CollectionProxy from 'collections/collection_proxy';
import RubricModel from 'models/rubric';
import RubricModalView from 'views/modal/modal_rubric';

export default class ProjectDetail extends Marionette.LayoutView {
  constructor() {

    this.template = template;

    this.regions = {
      projectScoreOverview: '[data-region="project-score-overview"]',
      projectStudentSubmissionList: '[data-region="project-student-submission-list"]',
      projectGroupSubmissionList: '[data-region="project-group-submission-list"]'
    };

    this.triggers = {
      'click @ui.showRubric': 'open:rubric:modal'
    };

    this.ui = {
      showRubric: '[data-behavior="show-rubric"]'
    };
  }

  initialize(options) {
    this.options = options || {};
    this.vent = Marionette.getOption(this, 'vent');
    this.creatorType = Marionette.getOption(this, 'creatorType');
    this.projectType = this.model.get('type');
    this.projectId = Marionette.getOption(this, 'projectId') || this.model.id;
    this.projectStatisticsModel = new ProjectStatisticsModel({id: this.projectId});
    this.projectStatisticsModel.fetch({reset: true});
    this.collection = new SubmissionCollection([]);
    this.collection.fetch({
      reset: true,
      data: {project: this.projectId, statistics: true}
    });
    return this.filterLists();
  }

  filterLists() {
    this.groupSubmissions = new CollectionProxy(this.collection);
    this.groupSubmissions.where(model => model.get('creator_type') === 'Group');
    this.studentSubmissions = new CollectionProxy(this.collection);
    return this.studentSubmissions.where(model => model.get('creator_type') === 'User');
  }

  renderTables(type) {
    if (this.projectType === 'UserProject') {
      return this.projectStudentSubmissionList.show(new ProjectSubmissionListView({projectId: this.model.id, collection: this.studentSubmissions, vent: this}));
    } else if (this.projectType === 'GroupProject') {
      return this.projectGroupSubmissionList.show(new ProjectSubmissionListView({projectId: this.model.id, collection: this.groupSubmissions, vent: this}));
    } else {
      this.projectStudentSubmissionList.show(new ProjectSubmissionListView({projectId: this.model.id, collection: this.studentSubmissions, vent: this}));
      return this.projectGroupSubmissionList.show(new ProjectSubmissionListView({projectId: this.model.id, collection: this.groupSubmissions, vent: this}));
    }
  }

  onOpenRubricModal() {
    const rubric = new RubricModel(this.model.get('rubric'));
    return Vocat.vent.trigger('modal:open', new RubricModalView({model: rubric}));
  }

  serializeData() {
    return {
      project: this.model.toJSON()
    };
  }

  onShow() {
    return this.setupListeners();
  }

  onRender() {
    this.projectId = Marionette.getOption(this, 'projectId');
    this.projectScoreOverview.show(new ProjectScoreOverviewView({model: this.projectStatisticsModel}));
    return this.renderTables();
  }

  setupListeners() {
    return this.listenTo(this, 'navigate:asset', function(args) {
      console.log(args);
      return this.navigateToAsset(args.asset, args.course);
    });
  }

  navigateToAsset(assetId, courseId) {
    const url = `courses/${courseId}/assets/${assetId}`;
    return Vocat.router.navigate(url, true);
  }
};