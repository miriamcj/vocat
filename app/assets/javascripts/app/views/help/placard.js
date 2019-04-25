/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */




import { reject } from "lodash";

export default class Placard extends Backbone.View.extend({
  orientations: ['nnw', 'nne', 'ene', 'ese', 'sse', 'ssw', 'wsw', 'wnw'],
  locked: false,
  hideTimeout: null,
  leftPositionAdjust: 0,
  topPositionAdjust: -5,
  visible: false
}) {
  // options.orientation = where the placard should display
  // options.key = when help:show is triggered, a data is object that contains a key (data.key). The key must match options.key for this placard to be shown.
  // options.showtest = () -> true || false -- an anonymous function to be execute before the placard is shown.
  // options.key and options.orientation can also be set on the placard <aside> element as data-key and data-orienation attributes. This is useful for placards generated server-side.
  initialize(options) {
    this.options = options;

    const data = this.$el.data();
    if ((data.key != null) && !this.options.key) { this.options.key = data.key; }
    if ((data.orientation != null) && !this.options.orientation) { this.options.orientation = data.orientation; }

    this.initializeEvents();
    if (typeof(this['onInitialize']) === 'function') {
      return this.onInitialize();
    }
  }


  initializeEvents() {
    this.$el.bind('mouseenter', () => {
      return Vocat.vent.trigger('help:show', this.shownData);
    });

    this.$el.bind('mouseleave', () => {
      return Vocat.vent.trigger('help:hide', {key: this.options.key});
    });

    this.listenTo(Vocat.vent, 'help:show', data => {
      let showTestResults;
      if ((this.options.showTest != null) && (typeof this.options.showTest === 'function')) {
        showTestResults = this.options.showTest();
      } else {
        showTestResults = true;
      }

      // I was totally talking to you, so please show
      if ((data.key != null) && (data.key === this.options.key) && showTestResults) {
        return this.show(data);
      } else {
        // I wasn't talking to you, so please hide
        return this.hide();
      }
    });

    return this.listenTo(Vocat.vent, 'help:hide', data => {
      // if @hideTimeout is not null, a hide has already been requested.
      if (this.hideTimeout === null) {
        return this.hideTimeout = setTimeout(() => {
          if ((data.key != null) && (data.key === this.options.key)) {
            return this.hide();
          }
        }
        , 100);
      }
    });
  }

  positionOn(targetEl, orientation) {
    const $targetEl = $(targetEl);

    // Get width and height
    this.$el.css({top: -9999, left: -9999});
    this.$el.show();
    const myHeight = this.$el.outerHeight();
    const myWidth = this.$el.width();
    const targetOffset = $targetEl.offset();
    const targetOffsetLeft = targetOffset.left;
    const targetOffsetTop = targetOffset.top;
    const targetHeight = $targetEl.outerHeight();
    const targetWidth = $targetEl.outerWidth();

    this.$el.hide();

    // Determine natural offset
    const containerOffset = $('.page-content').offset();
    const containerOffsetLeft = containerOffset.left;
    const onOffset = $targetEl.offset();
    let myOffsetTop = (onOffset.top - containerOffset.top) + this.topPositionAdjust;
    let myOffsetLeft = this.leftPositionAdjust;

    // Adjust offset based on orientation
    orientation = this.validateOrienation(orientation);
    if (orientation != null) {
      switch (orientation) {
        case 'nnw':
          myOffsetLeft = (targetOffsetLeft - containerOffsetLeft);
          myOffsetTop += targetHeight;
          if (targetWidth < 65) { myOffsetLeft -= (65 - (targetWidth / 2)); }
          break;
        case 'nne':
          myOffsetLeft = (((targetOffsetLeft - containerOffsetLeft) - myWidth) + targetWidth) - 45;
          myOffsetTop += targetHeight;
          if (targetWidth < 65) { myOffsetLeft += (65 - (targetWidth / 2)); }
          break;
        case 'ene':
          myOffsetLeft = (targetOffsetLeft - containerOffsetLeft) - myWidth - 60;
          myOffsetTop += 5;
          if (targetHeight < 45) { myOffsetTop -= (45 - (targetHeight / 2) - 5); }
          break;
        case 'ese':
          myOffsetLeft = (targetOffsetLeft - containerOffsetLeft) - myWidth - 62;
          myOffsetTop -= myHeight - targetHeight - 5;
          if (targetHeight < 45) { myOffsetTop += (45 - (targetHeight / 2) - 5); }
          break;
        case 'sse':
          myOffsetLeft = (((targetOffsetLeft - containerOffsetLeft) - myWidth) + targetWidth) - 45;
          myOffsetTop -= myHeight + 12;
          if (targetWidth < 65) { myOffsetLeft += (65 - (targetWidth / 2)); }
          break;
        case 'ssw':
          myOffsetLeft = (targetOffsetLeft - containerOffsetLeft);
          myOffsetTop -= myHeight + 12;
          if (targetWidth < 65) { myOffsetLeft -= (65 - (targetWidth / 2)); }
          break;
        case 'wsw':
          myOffsetLeft = (targetOffsetLeft - containerOffsetLeft) + targetWidth;
          myOffsetTop -= myHeight - targetHeight - 5;
          if (targetHeight < 45) { myOffsetTop += (45 - (targetHeight / 2) - 5); }
          break;
        case 'wnw':
          myOffsetLeft = (targetOffsetLeft - containerOffsetLeft) + targetWidth;
          myOffsetTop += 5;
          if (targetHeight < 45) { myOffsetTop -= (45 - (targetHeight / 2) - 5); }
          break;
      }
    }

    const newPosition = {
      top: myOffsetTop,
      left: myOffsetLeft
    };

    this.$el.css(newPosition);
    return this.shownOn = targetEl;
  }

  validateOrienation(orientation) {
    if ((orientation != null) && (this.orientations.indexOf(orientation) !== -1)) {
      this.$el.addClass(orientation).removeClass(reject(this.orientations, value => value === orientation).join(' '));
      return orientation;
    } else {
      return null;
    }
  }

  show(data) {
    let orientation;
    if (this.hideTimeout) {
      clearTimeout(this.hideTimeout);
      this.hideTimeout = null;
    }

    if (data.orientation) {
      ({ orientation } = data);
    } else {
      ({ orientation } = this.options);
    }

    this.positionOn(data.on, orientation);
    this.shownData = data;
    this.trigger('before:show', data);
    this.$el.show();
    this.visible = true;
    return this.trigger('after:show', data);
  }

  hide() {
    this.trigger('before:hide');
    this.$el.hide();
    this.visible = false;
    return this.trigger('after:hide');
  }
}
