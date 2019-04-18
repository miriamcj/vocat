/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import ProjectModel from 'models/project';
let ProjectCollection;

export default ProjectCollection = (function() {
  ProjectCollection = class ProjectCollection extends Backbone.Collection {
    static initClass() {

      this.prototype.model = ProjectModel;

      this.prototype.activeModel = null;
    }

    getActive() {
      return this.activeModel;
    }

    hasGroupProjects() {
      const p = this.filter(function(model) {
        const t = model.get('type');
        return (t === 'GroupProject') || (t === 'OpenProject');
      });
      return p.length > 0;
    }

    hasUserProjects() {
      const p = this.filter(function(model) {
        const t = model.get('type');
        return (t === 'UserProject') || (t === 'OpenProject');
      });
      return p.length > 0;
    }

    setActive(id) {
      const current = this.getActive();
      if (id != null) {
        const model = this.get(id);
        if (model != null) {
          this.activeModel = model;
        } else {
          this.activeModel = null;
        }
      } else {
        this.activeModel = null;
      }
      if (this.activeModel !== current) {
        return this.trigger('change:active', this.activeModel);
      }
    }
  };
  ProjectCollection.initClass();
  return ProjectCollection;
})();
