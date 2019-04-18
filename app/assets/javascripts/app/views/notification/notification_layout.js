/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/notification/notification_layout';
import NotificationMessage from 'views/notification/notification_message';
import NotificationRegion from 'views/notification/notification_region';
import FlashMessageModel from 'models/flash_message';

export default class NotificationLayout extends Marionette.LayoutView {
  constructor() {

    this.notificationCounter = 0;
    this.notificationRegion = null;

    this.className = 'notification';
    let notificationRegion = null;
    this.template = template;
  }

  initialize(options) {
    return this.setupEvents();
  }

  onShow() {
    return this.loadServerSideFlashMessages();
  }

  setupEvents() {
    this.listenTo(this.getOption('vent'), 'error:add', messageParams => {
      return this.handleIncomingMessages(messageParams);
    });
    this.listenTo(this.getOption('vent'), 'notification:show', view => {
      return this.handleIncomingNotification(view);
    });
    this.listenTo(this.getOption('vent'), 'notification:empty', () => {
      return this.handleEmptyNotification();
    });
    return this.listenTo(this.regionManager, 'transition:start', (height, timing) => {
      return this.adjustPosition(height, timing);
    });
  }

  adjustPosition(height, timing) {
    let distance;
    const $container = $('.container');
    const marginTop = parseInt($container.css('marginTop').replace('px', ''));
    const newMargin = marginTop + height;
    $container.animate({marginTop: `${newMargin}px`}, timing);
    return distance = height - marginTop;
  }

  handleEmptyNotification() {
    this.regionManager.removeRegions();
    const $container = $('.container');
    const newMargin = 0;
    return $container.animate({marginTop: `${newMargin}px`}, 0);
  }

  handleIncomingNotification(view) {
    if ((this.notificationRegion == null)) {
      const regionId = this.makeRegion();
      this.notificationRegion = this[regionId];
      this.listenTo(this.notificationRegion, 'empty', () => {
        return this.notificationRegion = null;
      });
    }
    if (!this.notificationRegion.hasView()) {
      return this.notificationRegion.show(view);
    }
  }

  handleIncomingMessages(params) {
    if (params.hasOwnProperty('clear') && (params.clear === true)) {
      this.handleEmptyNotification();
    }
    const views = this.messageViewsFromMessageParams(params);
    return _.each(views, view => {
      const regionId = this.makeRegion();
      return this[regionId].show(view);
    });
  }

  getAndIncrementNotificationCounter() {
    const r = this.notificationCounter;
    this.notificationCounter++;
    return r;
  }

  makeRegion() {
    const regionId = `notificationRegion${this.getAndIncrementNotificationCounter()}`;
    const $regionEl = $(`<div style="display: none;" class="notification-item" id="${regionId}"></div>`);
    this.$el.append($regionEl);
    const region = this.addRegion(regionId, {selector: `#${regionId}`, regionClass: NotificationRegion});
    this.listenTo(this[regionId], 'region:expired', () => {
      return this.regionManager.removeRegion(regionId);
    });
    this.regionManager.listenTo(this[regionId], 'transition:start', (height, timing) => {
      return this.regionManager.trigger('transition:start', height, timing);
    });
    this.regionManager.listenTo(this[regionId], 'transition:complete', (height, timing) => {
      return this.regionManager.trigger('transition:complete', height, timing);
    });
    return regionId;
  }

  messageViewsFromMessageParams(params) {
    let views;
    if (!_.isString(params.msg) && (_.isObject(params.msg) || _.isArray(params.msg))) {
      views = this.viewsFromComplexMessageParams(params);
    } else {
      views = [];
      views.push(this.makeOneNotificationView(params));
    }
    return views;
  }

  viewsFromComplexMessageParams(params) {
    let level, lifetime;
    const views = [];
    if (params.level != null) { ({ level } = params); } else { level = 'notice'; }
    if (params.lifetime != null) { ({ lifetime } = params); } else { lifetime = null; }
    if (_.isArray(params.msg)) {
      if (params.msg.length > 0) {
        _.each(params.msg, msg => {
          return views.push(this.makeOneNotificationView({
            level,
            msg,
            property: null,
            lifetime
          }));
        });
      }
    } else if (_.isObject(params.msg)) {
      _.each(params.msg, (text, property) => {
        if (property === 'base') {
          return views.push(this.makeOneNotificationView({
            level,
            msg: text,
            property: null,
            lifetime
          })
          );
        } else {
          return views.push(this.makeOneNotificationView({
            level,
            msg: `${property.charAt(0).toUpperCase() + property.slice(1)} ${text}`,
            property: null,
            lifetime
          }));
        }
      });
    } else {
      views.push(this.makeOneNotificationView({
        level,
        msg: params.msg,
        property: null,
        lifetime
      })
      );
    }
    return views;
  }

  makeOneNotificationView(params) {
    let view;
    const model = new FlashMessageModel({
      msg: params.msg,
      level: params.level,
      property: params.property,
      lifetime: params.lifetime
    });
    return view = new NotificationMessage({
      model
    });
  }

  loadServerSideFlashMessages() {
    const dataContainer = $("#bootstrap-globalFlash");
    if (dataContainer.length > 0) {
      const div = $('<div></div>');
      div.html(dataContainer.text());
      const text = div.text();
      if ((text != null) && !(/^\s*$/).test(text)) {
        const data = JSON.parse(text);
        if (_.isArray(data.globalFlash)) {
          return _.each(data.globalFlash, msg => {
            return this.handleIncomingMessages(msg);
          });
        }
      }
    }
  }
};
