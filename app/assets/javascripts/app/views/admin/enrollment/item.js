/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import userItemTemplate from 'hbs!templates/admin/enrollment/list_users_item';
import courseItemTemplate from 'hbs!templates/admin/enrollment/list_courses_item';

export default CreatorEnrollmentItem = (function() {
  CreatorEnrollmentItem = class CreatorEnrollmentItem extends Marionette.ItemView {
    constructor(...args) {
      {
        // Hack: trick Babel/TypeScript into allowing this before super.
        if (false) { super(); }
        let thisFn = (() => { return this; }).toString();
        let thisName = thisFn.match(/return (?:_assertThisInitialized\()*(\w+)\)*;/)[1];
        eval(`${thisName} = this;`);
      }
      this.getTemplate = this.getTemplate.bind(this);
      super(...args);
    }

    static initClass() {

      this.prototype.tagName = 'tr';
    }

    getTemplate() {
      if (this.model.collection.searchType() === 'user') { return userItemTemplate; } else { return courseItemTemplate; }
    }

    triggers() {
      return {'click [data-behavior="destroy"]': 'clickDestroy'};
    }

    initialize(options) {
      return this.vent = options.vent;
    }

    serializeData() {
      const out = super.serializeData();
      out.isAdmin = (window.VocatUserRole === 'administrator');
      return out;
    }

    onClickDestroy() {
      return this.model.destroy({
        wait: true,
        success: model => {
          return Vocat.vent.trigger('error:add', {
            level: 'notice',
            lifetime: 5000,
            msg: `${model.get('user_name')} has been removed from section #${model.get('section')}.`
          });
        },
        error: (model, xhr) => {
          return Vocat.vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: xhr.responseJSON.errors});
        }
      });
    }

    onRender() {}
  };
  CreatorEnrollmentItem.initClass();
  return CreatorEnrollmentItem;
})();
