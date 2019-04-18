/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ProjectView;
import marionette from 'marionette';
import Pikaday from 'vendor/plugins/pikaday';

export default ProjectView = (function() {
  ProjectView = class ProjectView extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = false;

      this.prototype.ui = {
        checkboxMediaAny: '[data-behavior="media-any"]',
        checkboxMediaSpecific: '[data-behavior="media-specific"]'
      };

      this.prototype.triggers = {
        'change @ui.checkboxMediaAny': 'media:any:change',
        'change @ui.checkboxMediaSpecific': 'media:specific:change'
      };
    }

    onMediaAnyChange() {
      if (this.ui.checkboxMediaAny.prop('checked') === true) {
        return this.ui.checkboxMediaSpecific.each((i, el) => $(el).prop('checked', false));
      }
    }

    onMediaSpecificChange() {
      const checkedCount = this.$el.find('[data-behavior="media-specific"]:checked').length;
      if (checkedCount > 0) {
        return this.ui.checkboxMediaAny.prop('checked', false);
      } else {
        return this.ui.checkboxMediaAny.prop('checked', true);
      }
    }

    initialize() {}
  };
  ProjectView.initClass();
  return ProjectView;
})();
