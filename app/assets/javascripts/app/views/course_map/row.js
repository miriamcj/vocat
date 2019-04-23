/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import ItemView from 'views/course_map/cell';

export default class Row extends Marionette.CollectionView {
  constructor(options) {
    super(options);

    // @model = a user model or a group model (in other words, a creator)
    // @collection = projects collection
    // this view is a collection view. It creates a cell for each project.

    this.tagName = 'tr';
    this.childView = ItemView;

    this.triggers = {
      'mouseover': 'row:active',
      'mouseout': 'row:inactive'
    };
  }

  onRowActive() {
    return this.vent.triggerMethod('row:active', {creator: this.model});
  }

  onRowInactive() {
    return this.vent.triggerMethod('row:inactive', {creator: this.model});
  }

  childViewOptions() {
    return {
    vent: this.vent,
    creator: this.model,
    submissions: this.submissions
    };
  }

  initialize(options) {
    this.vent = options.vent;
    this.submissions = options.collections.submission;
    this.creatorType = options.creatorType;

    if (this.creatorType === 'Group') {
      this.$el.addClass('matrix--group-row');
    }

    this.listenTo(this.vent, 'row:active', function(data) {
      if (data.creator === this.model) { return this.$el.addClass('active'); }
    });

    return this.listenTo(this.vent, 'row:inactive', function(data) {
      if (data.creator === this.model) { return this.$el.removeClass('active'); }
    });
  }
};
