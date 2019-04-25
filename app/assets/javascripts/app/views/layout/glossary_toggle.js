/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


export default class GlossaryToggleView extends Backbone.View.extend({}) {

  initialize() {
    const input = this.$el.find('input');
    input.click(event => {
      window.Vocat.trigger('glossary:enabled:toggle');
      return this.updateUi();
    });
    window.Vocat.on('glossary:enabled:updated', () => {
      return this.updateUi();
    });
    return this.updateUi();
  }


  updateUi() {
    const input = this.$el.find('input');
    if (Vocat.glossaryEnabled === true) {
      this.$el.find('label').addClass('active');
      return input.attr('checked', true);
    } else {
      this.$el.find('label').removeClass('active');
      return input.attr('checked', false);
    }
  }
};
