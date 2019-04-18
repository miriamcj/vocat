/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ProjectDialogView;
const Marionette = require('marionette');
const template = require('hbs!templates/project/dialog');

export default ProjectDialogView = (function() {
  ProjectDialogView = class ProjectDialogView extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;
    }

    initialize() {
      return this.model.fetch();
    }
  };
  ProjectDialogView.initClass();
  return ProjectDialogView;
})();