import {} from 'jquery-ujs';


export default class ChosenView extends Marionette.ItemView {
  constructor(options) {
    super(options);
  }

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
};
