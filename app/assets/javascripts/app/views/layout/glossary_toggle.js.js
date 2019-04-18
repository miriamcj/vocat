/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define([
  'backbone'
], function(Backbone) {
  let GlossaryToggleView;
  return (GlossaryToggleView = class GlossaryToggleView extends Backbone.View {

    initialize() {
      const input = this.$el.find('input');
      input.click(event => {
        Vocat.trigger('glossary:enabled:toggle');
        return this.updateUi();
      });
      Vocat.on('glossary:enabled:updated', () => {
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
  });
});
