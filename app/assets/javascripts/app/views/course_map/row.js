/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['marionette', 'views/course_map/cell'], function(Marionette, ItemView) {
  let Row;
  return Row = (function() {
    Row = class Row extends Marionette.CollectionView {
      static initClass() {
  
        // @model = a user model or a group model (in other words, a creator)
        // @collection = projects collection
        // this view is a collection view. It creates a cell for each project.
  
        this.prototype.tagName = 'tr';
        this.prototype.childView = ItemView;
  
        this.prototype.triggers = {
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
    Row.initClass();
    return Row;
  })();
});


