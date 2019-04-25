/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import SubmissionTemplate from 'templates/portfolio/portfolio_item_submission.hbs';

export default class PortfolioItemSubmission extends Marionette.ItemView.extend({
  template: SubmissionTemplate,
  className: 'page-section portfolio-item portfolio-course-submissions',
  standalone: false,

  ui: {
    submissionLink: '[data-behavior="open-submission-detail"]'
  }
}) {
  triggers() {
    const t = {
    };
    if (this.standalone !== true) {
      t['click @ui.submissionLink'] = 'open:submission';
    }
    return t;
  }

  onOpenSubmission() {
    const typeSegment = `${this.model.get('creator_type').toLowerCase()}s`;
    const url = `courses/${this.courseId}/${typeSegment}/evaluations/creator/${this.model.get('creator_id')}/project/${this.model.get('project_id')}`;
    return window.Vocat.router.navigate(url, true);
  }

  setupListeners() {
    return this.listenTo(this.model, 'change', () => {
      return this.render();
    });
  }


  initialize(options) {
    this.courseId = Marionette.getOption(this, 'courseId');
    this.standalone = Marionette.getOption(this, 'standalone');
    this.vent = Marionette.getOption(this, 'vent');
    this.creator = Marionette.getOption(this, 'creator');
    return this.setupListeners();
  }

  serializeData() {
    const data = super.serializeData();
    const out = {
      submission: data,
      isGroupProject: this.model.get('creator_type') === 'Group'
    };
    return out;
  }
};
