/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/assets/asset_collection_empty.hbs';

export default class AssetCollectionEmpty extends Marionette.ItemView {
  constructor() {

    this.template = template;
    this.abilities = {};

    this.ui = {
      manageLink: '[data-behavior="empty-manage-link"]'
    };

    this.triggers = {
      'click @ui.manageLink': 'show:new'
    };
  }

  onShowNew() {
    return this.vent.triggerMethod('request:state:manage');
  }

  serializeData() {
    const context = this.abilities;
    context.mediaUploadsClosed = this.model.pastDue() && this.model.get('rejects_past_due_media') && (window.VocatUserCourseRole === 'creator');
    context.allowed_attachment_families = this.model.get('allowed_attachment_families');
    return context;
  }

  initialize(options) {
    this.vent = Marionette.getOption(this, 'vent');
    return this.abilities = Marionette.getOption(this, 'abilities');
  }
};
