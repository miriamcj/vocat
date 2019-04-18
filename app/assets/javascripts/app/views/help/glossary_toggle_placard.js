/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import Placard from 'views/help/placard';
import template from 'hbs!templates/help/glossary_toggle_placard';

export default GlossaryTogglePlacard = (function() {
  GlossaryTogglePlacard = class GlossaryTogglePlacard extends Placard {
    static initClass() {

      this.prototype.events = {
        'change [data-toggle-glossary]': 'onToggleGlossary'
      };

      this.prototype.template = template;
      this.prototype.className = 'placard';
      this.prototype.tagName = 'aside';
      this.prototype.attributes = {
        style: 'display: none'
      };
    }

    onToggleGlossary(e) {
      Vocat.trigger('glossary:enabled:toggle');
      return this.render();
    }

    serializeData() {
      let out;
      return out = {
        rubric: this.options.rubric,
        glossaryEnabled: Vocat.glossaryEnabled
      };
    }

    onInitialize() {}

    render() {
      return $('.page-content').prepend(this.$el.html(this.template(this.serializeData())));
    }
  };
  GlossaryTogglePlacard.initClass();
  return GlossaryTogglePlacard;
})();
