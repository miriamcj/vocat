/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let SubmissionLayout;
const Marionette = require('marionette');
const template = require('hbs!templates/submission/submission_layout');
const DiscussionView = require('views/discussion/discussion');
const EvaluationsView = require('views/submission/evaluations/evaluations_layout');
const AssetsView = require('views/assets/assets_layout');
const UtilityView = require('views/submission/utility/utility');
const ModalGroupMembershipView = require('views/modal/modal_group_membership');
const ProjectModalView = require('views/modal/modal_project_description');
const RubricModalView = require('views/modal/modal_rubric');
const MarkdownOverviewModalView = require('views/modal/modal_markdown_overview');
const RubricModel = require('models/rubric');
const VisitCollection = require('collections/visit_collection');

export default SubmissionLayout = (function() {
  SubmissionLayout = class SubmissionLayout extends Marionette.LayoutView {
    static initClass() {

      this.prototype.template = template;
      this.prototype.children = {};
      this.prototype.courseMapContext = true;

      this.prototype.triggers = {
        'click @ui.openGroupModal': 'open:groups:modal',
        'click @ui.close': 'close',
        'click @ui.showProjectDescriptionModal': 'open:project:modal',
        'click @ui.showRubric': 'open:rubric:modal',
        'click @ui.showMarkdownOverview': 'open:markdown:modal'
      };

      this.prototype.ui = {
        close: '[data-behavior="detail-close"]',
        openGroupModal: '[data-behavior="open-group-modal"]',
        showProjectDescriptionModal: '[data-behavior="open-project-description"]',
        showRubric: '[data-behavior="show-rubric"]',
        showMarkdownOverview: '[data-behavior="show-markdown-overview"]'
      };

      this.prototype.regions = {
        flash: '[data-region="flash"]',
        evaluations: '[data-region="submission-evaluations"]',
        discussion: '[data-region="submission-discussion"]',
        assets: '[data-region="submission-assets"]',
        utility: '[data-region="submission-utility"]'
      };
    }

    serializeData() {
      const sd ={
        project: this.project.toJSON(),
        projectEvaluatable: this.model.get('project').evaluatable,
        courseId: this.courseId,
        creator: this.creator.toJSON(),
        creatorType: this.model.get('creator_type'),
        isGroupProject: this.model.get('creator_type') === 'Group',
        courseMapContext: this.courseMapContext,
        pastDueDate: this.project.pastDue()
      };
      return sd;
    }

    onDomRefresh() {
      return window.scrollTo(0, 0);
    }

    onOpenGroupsModal() {
      return Vocat.vent.trigger('modal:open', new ModalGroupMembershipView({groupId: this.creator.id}));
    }

    onOpenProjectModal() {
      return Vocat.vent.trigger('modal:open', new ProjectModalView({model: this.project}));
    }

    onOpenRubricModal() {
      const rubric = new RubricModel(this.project.get('rubric'));
      return Vocat.vent.trigger('modal:open', new RubricModalView({model: rubric}));
    }

    onOpenMarkdownModal() {
      return Vocat.vent.trigger('modal:open', new MarkdownOverviewModalView());
    }

    onClose() {
      let url;
      const context = this.model.get('creator_type').toLowerCase() + 's';
      if (this.courseMapContext) {
        url = `courses/${this.courseId}/${context}/evaluations`;
        return Vocat.router.navigate(url, true);
      } else {
        url = `/courses/${this.courseId}/portfolio`;
        return window.location = url;
      }
    }

    onShow() {
      if (!this.$el.parent().data().hasOwnProperty('hideBackLink')) {
        this.ui.close.show();
      }
      this.discussion.show(new DiscussionView({submission: this.model}));
      if (this.model.get('project').evaluatable) {
        this.evaluations.show(new EvaluationsView({
          rubric: this.rubric,
          vent: this,
          project: this.project,
          model: this.model,
          courseId: this.courseId
        }));
      }
      this.assets.show(new AssetsView({
        collection: this.model.assets(),
        model: this.model,
        courseId: this.courseId,
        initialAsset: this.options.initialAsset,
        courseMapContext: this.courseMapContext
      }));
      if (this.model.get('abilities').can_administer) {
        return this.utility.show(new UtilityView({vent: this.vent, model: this.model, courseId: this.courseId}));
      }
    }

    initialize(options) {
      this.options = options || {};
      this.collections = {};
      this.courseId = Marionette.getOption(this, 'courseId');
      this.courseMapContext = Marionette.getOption(this, 'courseMapContext');
      this.project = this.model.project();
      this.creator = this.model.creator();

      const visitCollection = new VisitCollection;
      this.visit = new visitCollection.model({visitable_type: "Submission", visitable_id: this.model.id, visitable_course_id: this.courseId});
      visitCollection.add(this.visit);
      return this.visit.save();
    }
  };
  SubmissionLayout.initClass();
  return SubmissionLayout;
})();
