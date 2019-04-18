/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let EnrollmentUserList;
const Marionette = require('marionette');
const ItemView = require('views/admin/enrollment/item');
const EmptyCoursesView = require('views/admin/enrollment/empty_courses');
const EmptyUsersView = require('views/admin/enrollment/empty_users');
const templateCourses = require('hbs!templates/admin/enrollment/list_courses');
const templateUsers = require('hbs!templates/admin/enrollment/list_users');

require('jquery_ui');
require('vendor/plugins/ajax_chosen');

export default EnrollmentUserList = (function() {
  EnrollmentUserList = class EnrollmentUserList extends Marionette.CompositeView {
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

      this.prototype.childViewContainer = "tbody";
      this.prototype.childView = ItemView;

      this.prototype.ui = {
        studentInput: '[data-behavior="student-input"]'
      };
    }

//    emptyView: EmptyCoursesView

    getTemplate() {
      if (this.collection.searchType() === 'user') { return templateUsers; } else { return templateCourses; }
    }

    childViewOptions() {
      return {
      role: this.collection.role(),
      vent: this.vent
      };
    }

    appendHtml(collectionView, childView, index) {
      let childrenContainer;
      if (collectionView.childViewContainer) {
        childrenContainer = collectionView.$(collectionView.childViewContainer);
      } else {
        childrenContainer = collectionView.$el;
      }

      const children = childrenContainer.children();
      if (children.size() <= index) {
        return childrenContainer.append(childView.el);
      } else {
        return children.eq(index).before(childView.el);
      }
    }

    initialize(options) {
      this.vent = options.vent;

      if (this.collection.searchType() === 'user') {
        this.emptyView = EmptyUsersView;
      } else {
        this.emptyView = EmptyCoursesView;
      }

      return this.collection.fetch();
    }
  };
  EnrollmentUserList.initClass();
  return EnrollmentUserList;
})();
