/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import DiscussionPostModel from 'models/discussion_post';
let DiscussionPostCollection;

export default DiscussionPostCollection = (function() {
  DiscussionPostCollection = class DiscussionPostCollection extends Backbone.Collection {
    static initClass() {

      this.prototype.model = DiscussionPostModel;

      this.prototype.url = '/api/v1/discussion_posts';
    }

    initialize(models, options) {
      if (options.submissionId != null) { this.submissionId = options.submissionId; }
      return this.bind('remove', model => {
        if (model.id != null) {
          const children = this.where({'parent_id': model.id});
          return _.each(children, child => {
            // We trigger a destroy event so that the model is removed from the collection and the view is removed from
            // memory. We don't do an actual destroy REST requset, because the children are deleted server-side when the
            // parent is deleted.
            return child.trigger('destroy', child, child.collection, {});
          });
        }
      });
    }

    getParentPosts() {
      return this.where({'parent_id': null});
    }

    getChildPosts() {
      return this.filter(post => post.get('parent_id') !== null);
    }
  };
  DiscussionPostCollection.initClass();
  return DiscussionPostCollection;
})();