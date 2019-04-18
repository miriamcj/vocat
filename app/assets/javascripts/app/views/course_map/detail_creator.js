/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import { $ } from "jquery";
import template from 'hbs!templates/course_map/detail_creator';
import PortfolioSubmissionItem from 'views/portfolio/portfolio_submissions_item';
import ModalGroupMembershipView from 'views/modal/modal_group_membership';

export default class CourseMapDetailCreator extends Marionette.CompositeView {
  constructor() {

    this.template = template;
    this.standalone = false;
    this.childView = PortfolioSubmissionItem;
    this.vent = Vocat.vent;

    this.childViewContainer = '[data-container="submission-summaries"]';

    this.ui = {
      loadIndicator: '[data-behavior="load-indicator"]',
      openGroupModal: '[data-behavior="open-group-modal"]'
    };
  }
  childViewOptions() {
    return {
    standalone: this.standalone,
    creator: this.model,
    vent: this.vent,
    courseId: this.courseId
    };
  }

  triggers() {
    const t = {
      'click @ui.openGroupModal': 'open:groups:modal'
    };
    if (this.standalone !== true) {
      t['click [data-behavior="detail-close"]'] = 'close';
    }
    return t;
  }

  onExecuteRoute(e) {
    e.preventDefault();
    const href = $(e.currentTarget).attr('href');
    if (href) {
      return window.Vocat.router.navigate(href, true);
    }
  }

  onOpenGroupsModal() {
    return Vocat.vent.trigger('modal:open', new ModalGroupMembershipView({groupId: this.model.id}));
  }

  onClose() {
    let segment = '';
    if (this.model.creatorType === 'User') { segment = 'users'; }
    if (this.model.creatorType === 'Group') { segment = 'groups'; }
    const url = `courses/${this.courseId}/${segment}/evaluations`;
    return Vocat.router.navigate(url, true);
  }

  initialize(options) {
    this.options = options || {};
    this.standalone = Marionette.getOption(this, 'standalone');
    this.courseId = Marionette.getOption(this, 'courseId');
    if (this.model.creatorType === 'User') {
      this.collection.fetch({data: {course: this.courseId, user: this.model.id}});
    } else {
      this.collection.fetch({
        data: {group: this.model.id}, success() {}
      });
    }

    return this.listenTo(this.collection, 'sync', () => {
      return this.ui.loadIndicator.hide();
    });
  }

  serializeData() {
    const data = super.serializeData();
    data['creatorType'] = this.model.creatorType;
    data['courseId'] = this.courseId;
    return data;
  }
}
