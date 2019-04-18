/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let AnnotationsView;
const Marionette = require('marionette');
const template = require('hbs!templates/assets/annotations/annotations');
const ItemView = require('views/assets/annotations/annotations_item');
const EmptyView = require('views/assets/annotations/annotations_item_empty');

export default AnnotationsView = (function() {
  AnnotationsView = class AnnotationsView extends Marionette.CompositeView {
    static initClass() {

      this.prototype.template = template;
      this.prototype.scrollLocked = false;
      this.prototype.highlighted = null;
      this.prototype.emptyView = EmptyView;

      this.prototype.className = 'annotations';

      this.prototype.triggers = {
        'click [data-behavior="show-all"]': 'show:all',
        'click [data-behavior="show-auto"]': 'show:auto',
        'click @ui.enableEdit': 'edit:enable',
        'click @ui.disableEdit': 'edit:disable'
      };

      this.prototype.childView = ItemView;

      this.prototype.childViewContainer = '[data-behavior="annotations-container"]';

      this.prototype.ui = {
        count: '[data-behavior="annotation-count"]',
        annotationsContainer: '[data-behavior="annotations-container"]',
        anchor: '[data-behavior="anchor"]',
        scrollParent: '[data-behavior="scroll-parent"]'
      };
    }

    childViewOptions(model, index) {
      return {
      model,
      vent: this.vent,
      assetHasDuration: this.model.hasDuration(),
      errorVent: this.vent
      };
    }

    onBeforeDestroy() {
      $(window).off("resize");
      $(window).off("scroll");
      return true;
    }

    unFade() {
      return this.ui.scrollParent.removeClass('annotations-faded');
    }

    passTimeToCollection(data) {
      return this.collection.setActive(data.playedSeconds);
    }

    setupListeners() {
      this.listenTo(this.vent, 'announce:time:update', this.unFade, this);
      this.listenTo(this.collection, 'model:activated', this.displayActive, this);
      this.listenTo(this, 'childview:activated', this.handleChildViewActivation, this);
      this.listenTo(this, 'childview:beforeRemove', this.lockScrolling, this);
      this.listenTo(this, 'childview:afterRemove', this.unlockScrolling, this);
      return this.listenTo(this.vent, 'announce:time:update', this.passTimeToCollection, this);
    }

    initialize(options) {
      this.vent = Marionette.getOption(this, 'vent');
      this.collection = this.model.annotations();
      return this.setupListeners();
    }

    handleChildViewActivation(view) {
      return this.displayActive();
    }

    lockScrolling() {
      return this.scrollLocked = true;
    }

    unlockScrolling() {
      return this.scrollLocked = false;
    }

    isScrolledIntoView($el) {
      const containerHeight = this.ui.scrollParent.outerHeight();
      const elTop = $el.position().top;
      const elBottom = elTop + $el.outerHeight();
      return (elTop > 0) && (elBottom <= containerHeight);
    }

    scrollToModel(speed, model) {
      if (speed == null) { speed = 250; }
      const view = this.children.findByModel(model);
      if (!this.isScrolledIntoView(view.$el)) {
        const targetPosition = view.$el.position().top;
        return this.ui.scrollParent.animate({scrollTop: this.ui.scrollParent.scrollTop() + targetPosition}, speed, 'swing');
      }
    }

    displayActive(speed) {
      if (speed == null) { speed = 250; }
      let activeModel = this.collection.findWhere({active: true});
      if (!this.model.hasDuration()) { return; }
      if (this.scrollLocked === false) {
        if (!activeModel) {
          activeModel = this.collection.last();
        }
        if (activeModel) {
          this.vent.trigger('request:annotation:show', activeModel);
          this.ui.scrollParent.removeClass('annotations-faded');
          return this.scrollToModel(speed, activeModel);
        }
      }
    }

    // Triggered by child childView; echoed up the event chain to the global event
    onPlayerSeek(data) {
      return this.vent.trigger('player:seek', data);
    }

    serializeData() {
      return {
      hasDuration: this.model.hasDuration(),
      count: this.collection.length,
      countNotOne: this.collection.length !== 1
      };
    }

    // See https://github.com/marionettejs/backbone.marionette/wiki/Adding-support-for-sorted-collections
    appendHtml(collectionView, childView, index) {
      let childrenContainer;
      if (collectionView.childViewContainer) {
        childrenContainer = collectionView.$(collectionView.childViewContainer);
      } else {
        childrenContainer = collectionView.$el;
      }
      const children = childrenContainer.children();
      if (children.size() <= index) {
        return childrenContainer.append(childView.el);
      } else {
        return childrenContainer.children().eq(index).before(childView.el);
      }
    }

    onShow() {
      return this.matchAnnotationsHeightToPlayerHeight();
    }

    matchAnnotationsHeightToPlayerHeight() {
      return this.ui.scrollParent.outerHeight($('[data-behavior="player-column"]').outerHeight());
    }

    onDestroy() {
      return $(window).off('scroll', this.scrollHandler);
    }
  };
  AnnotationsView.initClass();
  return AnnotationsView;
})();



