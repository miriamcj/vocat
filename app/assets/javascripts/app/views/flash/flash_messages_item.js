/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import { isArray, isObject } from "lodash";

import template from 'hbs!templates/flash/flash_messages_item';

export default class FlashMessagesItem extends Marionette.ItemView {
  constructor() {

    this.template = template;
    this.lifetime = 10000;

    this.triggers =
      {'click [data-behavior="destroy"]': 'destroy'};
  }

  className() {
    return `alert alert-${this.model.get('level')}`;
  }

  initialize(options) {
    const lifetime = parseInt(this.model.get('lifetime'));
    if (lifetime > 0) { return this.lifetime = lifetime; }
  }

  onDestroy() {
    return this.model.destroy();
  }
//      @$el.slideUp({
//        duration: 250
//        done: () =>
//          @model.destroy()
//      })

  onBeforeRender() {
    return this.$el.hide();
  }

  serializeData() {
    const context = super.serializeData();
    if (isArray(this.model.get('msg')) || isObject(this.model.get('msg'))) {
      context.enumerable = true;
    } else {
      context.enumerable = false;
    }
    return context;
  }

  onRender() {
    if (this.model.get('no_fade') === true) {
      this.$el.show();
    } else {
      this.$el.fadeIn();
    }


    return setTimeout(() => {
      return this.onDestroy();
    }
    , this.lifetime
    );
  }
}