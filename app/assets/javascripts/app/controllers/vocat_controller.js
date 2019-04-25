/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import LoadingView from 'views/layout/loading';
import ModalErrorView from 'views/modal/modal_error';

import {} from 'jquery-ujs';
import forEach from "lodash/forEach";

export default class VocatController extends Marionette.Controller.extend({
  collections: {
  }
}) {
  initialize() {
    return this.bootstrapCollections();
  }

  isBlank(str) {
    if (str === null) { str = ''; }
    return (/^\s*$/).test(str);
  }

  deferredCollectionFetching(collection, data, msg) {
    if (msg == null) { msg = "loading..."; }
    const deferred = $.Deferred();
    window.Vocat.main.show(new LoadingView({msg}));
    collection.fetch({
      reset: true,
      data,
      error: () => {
        return window.Vocat.vent.trigger('modal:open', new ModalErrorView({
          model: this.model,
          vent: this,
          message: 'Exception: Unable to fetch collection models. Please report this error to your VOCAT administrator.',
        }));
      },
      success: () => {
        return deferred.resolve();
      }
    });
    return deferred;
  }

  bootstrapCollections() {
    return forEach(this.collections, (collection, collectionKey) => {
      const dataContainer = $(`#bootstrap-${collectionKey}`);
      if (dataContainer.length > 0) {
        const div = $('<div></div>');
        div.html(dataContainer.text());
        const text = div.text();
        if (!this.isBlank(text)) {
          const data = JSON.parse(text);
          if (data[collectionKey] != null) { return collection.reset(data[collectionKey]); }
        }
      }
    });
  }
};
