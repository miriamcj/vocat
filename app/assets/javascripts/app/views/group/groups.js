/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let GroupsView;
  const Marionette = require('marionette');
  const Item = require('views/group/groups_item');
  const template = require('hbs!templates/group/groups');

  return GroupsView = (function() {
    GroupsView = class GroupsView extends Marionette.CompositeView {
      static initClass() {
  
        this.prototype.childView = Item;
        this.prototype.tagName = 'thead';
        this.prototype.template = template;
        this.prototype.childViewContainer = "tr";
      }

      childViewOptions() {
        return {
        courseId: this.options.courseId,
        vent: this.vent
        };
      }

      initialize(options) {
        this.options = options || {};
        return this.vent = Marionette.getOption(this, 'vent');
      }

      onAddChild() {
        return this.vent.trigger('recalculate');
      }

      onRemoveChild() {
        return this.vent.trigger('recalculate');
      }
    };
    GroupsView.initClass();
    return GroupsView;
  })();
});

