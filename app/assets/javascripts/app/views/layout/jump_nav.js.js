/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['jquery_rails', 'vendor/plugins/chosen'], function($) {
  let JumpNavView;
  const Marionette = require('marionette');

  return (JumpNavView = class JumpNavView extends Marionette.ItemView {


    handleChange() {
      const value = this.$el.val();
      return window.location = value;
    }

    initialize() {
      let msg;
      const data = this.$el.data();
      if (data.hasOwnProperty('placeholder')) {
        msg = data.placeholder;
      } else {
        msg = 'Select an Option';
      }
      const options = {
        disable_search_threshold: 1000,
        allow_single_deselect: true,
        placeholder_text_single: msg
      };
      return this.$el.chosen(options).change(_.bind(this.handleChange, this));
    }
  });
});


