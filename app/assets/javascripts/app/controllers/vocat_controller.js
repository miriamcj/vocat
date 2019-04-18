/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let VocatController;
  const Marionette = require('marionette');
  const LoadingView = require('views/layout/loading');
  const ModalErrorView = require('views/modal/modal_error');
  const $ = require('jquery_rails');

  return VocatController = (function() {
    VocatController = class VocatController extends Marionette.Controller {
      static initClass() {
  
        this.prototype.collections = {
        };
      }

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
            return Vocat.vent.trigger('modal:open', new ModalErrorView({
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
        return _.each(this.collections, (collection, collectionKey) => {
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
    VocatController.initClass();
    return VocatController;
  })();
});
