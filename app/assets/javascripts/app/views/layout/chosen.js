/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['jquery_rails', 'vendor/plugins/chosen'], function($) {
  let ChosenView;
  const Marionette = require('marionette');

  return (ChosenView = class ChosenView extends Marionette.ItemView {

    initialize() {
      let msg = 'Select an Option';
      if (this.$el.hasClass('month')) { msg = 'Month'; }
      if (this.$el.hasClass('year')) { msg = 'Year'; }
      if (this.$el.hasClass('day')) { msg = 'Day'; }
      const options = {
        disable_search_threshold: 1000,
        allow_single_deselect: true,
        placeholder_text_single: msg
      };
      return this.$el.chosen(options);
    }
  });
});
