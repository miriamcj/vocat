/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import template from 'hbs!templates/discussion/post';
import DiscussionPostCollection from 'collections/discussion_post_collection';
import DiscussionPostModel from 'models/discussion_post';
import DiscussionBaseView from 'views/abstract/abstract_discussion';

export default PostView = (function() {
  PostView = class PostView extends DiscussionBaseView {
    static initClass() {

      this.prototype.template = template;

      this.prototype.childViewContainer = '[data-behavior="post-container"]';

      this.prototype.tagName = 'li';
    }

    initialize(options) {
      this.initializeFlash();
      this.allPosts = options.allPosts;
      this.submission = options.submission;
      this.vent = options.vent;
      this.collection = new DiscussionPostCollection([], {});
      return this.collection.reset(this.allPosts.where({parent_id: this.model.id}));
    }

    onConfirmDeleteToggle() {
      return this.$el.find('[data-behavior="delete-confirm"]:first').slideToggle(150);
    }

    onPostDelete() {
      this.allPosts.remove(this.model);
      return this.model.destroy({wait: true});
    }

    onReplyToggle() {
      return this.ui.inputToggle.slideToggle({duration: 200});
    }

    handleSavePost(e) {
      if (e.keyCode === 13) {
        e.preventDefault();
        e.stopPropagation();
        const postInput = $(e.currentTarget);
        // The actual saving of the post is handled in the discussions view.
        return this.vent.trigger('post:save', postInput);
      }
    }

    handleDestroyedPost() {
      return this.$el.fadeOut(250, () => {
        return this.remove();
      });
    }
  };
  PostView.initClass();
  return PostView;
})();

