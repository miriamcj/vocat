/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';

import { throttle } from "lodash";
import ClosesOnUserAction from 'behaviors/closes_on_user_action';

export default class HeaderDrawerView extends Marionette.ItemView {
  constructor() {

    this.visibleCourses = 5;
    this.filtered = false;

    this.behaviors = {
      closesOnUserAction: {
        behaviorClass: ClosesOnUserAction
      }
    };

    this.ui = {
      courseSelect: '[data-class="course-select"]',
      recentCourseSelect: '[data-class="recent-course-select"]'
    };
  }

  toggle() {
    if (this.$el.hasClass('drawer-open')) {
      return this.close();
    } else {
      return this.open();
    }
  }

  open() {
    $(`[data-drawer-target=\"${this.drawerTarget}\"]`).addClass('drawer-open');
    $(`[data-drawer-target=\"${this.drawerTarget}\"] a`).addClass('active');
    return this.triggerMethod('opened');
  }

  close() {
    $(`[data-drawer-target=\"${this.drawerTarget}\"]`).removeClass('drawer-open');
    $(`[data-drawer-target=\"${this.drawerTarget}\"] a`).removeClass('active');
    return this.triggerMethod('closed');
  }

  setupListeners() {
    this.ui.courseSelect.on('change', () => {
      const val = this.ui.courseSelect.val();
      return window.location.assign(val);
    });
    return this.ui.recentCourseSelect.on('change', () => {
      const val = this.ui.recentCourseSelect.val();
      return window.location.assign(val);
    });
  }

  setSpacing() {
    const trigger = $(`[data-drawer-target=\"${this.drawerTarget}\"][data-behavior=\"header-drawer-trigger\"]`);
    if (trigger.length > 0) {
      const { left } = trigger.offset();
      const myLeft = this.$el.offset().left;
      return this.$el.css({left: left + 'px'});
    }
  }


  initialize(options) {
    this.vent = options.vent;
    this.globalChannel = Backbone.Wreqr.radio.channel('global');
    this.drawerTarget = this.$el.data().drawerTarget;
    // Set Spacing on Load and again anytime the window is resized
    this.setSpacing();
    const throttledSpacing = throttle(() => {
      return this.setSpacing();
    }, 50);
    $(window).resize(() => {
      return throttledSpacing();
    });
    this.listenTo(this.globalChannel.vent, `drawer:${this.drawerTarget}:toggle`, () => {
      return this.toggle();
    });
    this.bindUIElements();

    options = {
      disable_search_threshold: 1000,
      allow_single_deselect: false,
      placeholder_text_single: 'Jump to a different course'
    };
    this.ui.courseSelect.chosen(options);

    return this.setupListeners();
  }
}