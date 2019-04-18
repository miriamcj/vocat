/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import courseTemplate from 'hbs!templates/admin/enrollment/course_input_item';
import userTemplate from 'hbs!templates/admin/enrollment/user_input_item';

export default class EnrollmentUserInputItem extends Marionette.ItemView {
  constructor() {

    this.tagName = 'li';
    this.className = 'active-result';
  }

  getTemplate() {
    if (this.model.get('section') != null) {
      return courseTemplate;
    } else {
      return userTemplate;
    }
  }

  initialize(options) {
    this.enrollmentCollection = options.enrollmentCollection;
    return this.vent = options.vent;
  }

  triggers() {
    return {'mousedown': 'click'};
  }

  onClick() {
    const enrollment = this.enrollmentCollection.newEnrollmentFromSearchModel(this.model);
    enrollment.save({}, {
      error: (model, xhr) => {
        return Vocat.vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: xhr.responseJSON.errors});
      },
      success: () => {
        this.enrollmentCollection.add(enrollment);
        this.trigger('add', enrollment);
        if (this.enrollmentCollection === 'users') {
          let article;
          const role = this.enrollmentCollection.role();
          const l = role[0];
          if ((l === 'a') || (l === 'e') || (l === 'i') || (l === 'o') || (l === 'u')) {
            article = 'an';
          } else {
            article = 'a';
          }
          return Vocat.vent.trigger('error:add', {
            level: 'notice',
            lifetime: 5000,
            msg: `${enrollment.get('user_name')} is now ${article} ${role} in section #${enrollment.get('section')}.`
          });
        } else {
          return Vocat.vent.trigger('error:add', {
            level: 'notice',
            lifetime: 5000,
            msg: `${enrollment.get('user_name')} is now enrolled in section ${enrollment.get('section')}`
          });
        }
      }
    });
    return this.trigger('clicked');
  }

  onRender() {}
};
