/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let CourseMapProjectsView;
  const Marionette = require('marionette');
  const Item = require('views/course_map/projects_item');
  const EmptyView = require('views/course_map/projects_empty');
  const template = require('hbs!templates/course_map/projects');

  return CourseMapProjectsView = (function() {
    CourseMapProjectsView = class CourseMapProjectsView extends Marionette.CompositeView {
      static initClass() {
  
        this.prototype.childView = Item;
        this.prototype.emptyView = EmptyView;
        this.prototype.tagName = 'thead';
        this.prototype.template = template;
        this.prototype.ui = {
          childContainer: '[data-container="children"]'
        };
      }

      attachHtml(collectionView, childView, index) {
        if (collectionView.isBuffering) {
          return collectionView.elBuffer.appendChild(childView.el);
        } else {
          return this.ui.childContainer.append(childView.el);
        }
      }

      attachBuffer(collectionView, buffer) {
        return this.ui.childContainer.append(buffer);
      }

      childViewOptions() {
        return {
        creatorType: this.creatorType,
        vent: this.vent,
        courseId: this.options.courseId
        };
      }

      onChildviewActive(view) {
        return this.vent.triggerMethod('col:active', {project: view.model});
      }

      onChildviewInactive(view) {
        return this.vent.triggerMethod('col:inactive', {project: view.model});
      }

      onChildviewDetail(view) {
        return this.vent.triggerMethod('open:detail:project', {project: view.model});
      }

      initialize(options) {
        this.options = options || {};
        this.creatorType = Marionette.getOption(this, 'creatorType');
        return this.vent = Marionette.getOption(this, 'vent');
      }

      addChild(item, ItemView, index) {
        if (this.creatorType === 'User') {
          if (item.get('accepts_group_submissions') === true) { return; }
        }
        if (this.creatorType === 'Group') {
          if (item.get('accepts_group_submissions') === false) { return; }
        }
        return super.addChild(...arguments);
      }

      onShow() {}
    };
    CourseMapProjectsView.initClass();
    return CourseMapProjectsView;
  })();
});
