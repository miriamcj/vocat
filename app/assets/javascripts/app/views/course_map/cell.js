/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import template from 'hbs!templates/course_map/cell';
import UserModel from 'models/user';
import GroupModel from 'models/group';
import EvaluationModel from 'models/evaluation';

export default class Cell extends Marionette.ItemView {
  constructor() {

    // @model = initially, a project model, but set to a submission model in the init function
    // @creator = a group or user model

    this.template = template;

    this.tagName = 'td';
    this.className = 'clickable';

    this.triggers = {
      'click': 'detail',
      'click [data-behavior="publish-toggle"]': 'publish:toggle'
    };
  }

  onDetail() {
    if (this.model) { const submissionId = this.model.id; }
    return this.vent.trigger('navigate:submission', {project: this.project.id, creator: this.creator.id});
  }

  onPublishToggle() {
    if (this.model.get('current_user_percentage')) {
      this.model.toggleEvaluationPublish();
      return this.$el.find('dd').toggleClass('switch-checked');
    } else {
      return this.onDetail();
    }
  }

  findModel() {
    if (this.creator instanceof UserModel) {
      this.creatorType = 'User';
    } else if (this.creator instanceof GroupModel) {
      this.creatorType = 'Group';
    }
    this.model = this.submissions.findWhere({creator_type: this.creatorType, creator_id: this.creator.id, project_id: this.project.id});

    if (this.model != null) {
      this.listenTo(this.model, 'change sync', function() {
        return this.render();
      });
      return this.render();
    }
  }

  serializeData() {
    let context;
    if (this.model != null) {
      const projectAbilities = this.project.get('abilities');
      context = super.serializeData();
      context.user_can_evaluate = projectAbilities.can_evaluate;
      context.can_be_evaluated = this.project.evaluatable();
      context.is_active = this.isActive();
      context.is_loaded = true;
    } else {
      context = {
        is_loaded: false
      };
    }
    return context;
  }

  isActive() {
    if (this.project.evaluatable() === false) { return true; }
    if ((this.model != null) && (this.model.get('current_user_has_evaluated') === true)) { return true; }
    return false;
  }

  initialize(options) {
    this.vent = options.vent;
    this.submissions = options.submissions;
    this.creator = options.creator;
    this.project = this.model;
    return this.findModel();
  }
};
