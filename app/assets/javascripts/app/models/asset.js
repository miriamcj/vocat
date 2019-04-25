/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import AnnotationCollection from 'collections/annotation_collection';

export default class AssetModel extends Backbone.Model.extend({
  annotationCollection: null,
  urlRoot: "/api/v1/assets",
  polls: 0
}) {
  techOrder() {
    switch (this.get('type')) {
      case 'Asset::Youtube':
        return ['youtube'];
      case 'Asset::Vimeo':
        return ['vimeo'];
      default:
        return ['html5'];
    }
  }

  initialize() {
    this.listenTo(this, 'sync change:annotations', () => {
      return this.updateAnnotationCollection();
    });
    return this.updateAnnotationCollection();
  }

  poll() {
    if (this.get('attachment_state') === 'processing') {
      const wait = Math.pow(2, Math.floor(this.polls / 5)) * 10000;
      this.polls++;
      return this.fetch({
        success: (model, response, options) => {
          if (model.get('attachment_state') === 'processing') {
            return setTimeout(() => {
              return this.poll();
            }
            , wait);
          }
        }
      });
    }
  }

  hasDuration() {
    const family = this.get('family');
    switch (family) {
      case 'video': return true;
      case 'image': return false;
      case 'audio': return true;
      default:
        return false;
    }
  }

  allowsVisibleAnnotation() {
    if (this.get('type') === 'Asset::Vimeo') { return false; }
    const family = this.get('family');
    switch (family) {
      case 'video': return true;
      case 'image': return true;
      case 'audio': return false;
      default:
        return false;
    }
  }

  updateAnnotationCollection() {
    if (!this.annotationCollection) {
      return this.annotationCollection = new AnnotationCollection(this.get('annotations'),
        {assetId: this.id, assetHasDuration: this.hasDuration()});
    } else {
      this.annotationCollection.reset(this.get('annotations'));
      return this.annotationCollection.assetHasDuration = this.hasDuration();
    }
  }

  annotations() {
    return this.annotationCollection;
  }
};
