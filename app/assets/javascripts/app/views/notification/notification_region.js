/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

export default class NotificationRegion extends Marionette.Region {
  constructor() {

    this.PROMISE = $.Deferred().resolve();

    this.expiring = false;
  }

  attachHtml(view) {
    this.$el.hide();
    return this.$el.empty().append(view.el);
  }

  onEmpty() {
    return this.$el.remove();
  }

  onShow(view) {
    const timing = 250;
    const h = this.$el.outerHeight();

    NotificationRegion.PROMISE = NotificationRegion.PROMISE.then(() => {
      if (!view.isFlash) { this.trigger('transition:start', h, timing); }
      const p = $.Deferred();
      this.$el.fadeIn(timing, () => {
        p.resolve();
        if (!view.isFlash) { return this.trigger('transition:complete', h, timing); }
      });
      return p;
    });

    return this.listenTo(view, 'view:expired', () => {
      if (this.expiring === false) {
        this.expiring = true;
        return NotificationRegion.PROMISE = NotificationRegion.PROMISE.then(() => {
          if (!view.isFlash) { this.trigger('transition:start', h * -1, timing); }
          const p = $.Deferred();
          this.$el.fadeOut(timing, () => {
            p.resolve();
            if (!view.isFlash) { this.trigger('transition:complete', h * -1, timing); }
            return this.trigger('region:expired');
          });
          return p;
        });
      }
    });
  }
};
