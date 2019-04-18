/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import template from 'hbs!templates/discussion/discussion';
import DiscussionPostCollection from 'collections/discussion_post_collection';
import PostView from 'views/discussion/post';
import AbstractDiscussionView from 'views/abstract/abstract_discussion';
import DiscussionPostModel from 'models/discussion_post';

export default DiscussionView = (function() {
  DiscussionView = class DiscussionView extends AbstractDiscussionView {
    static initClass() {

      this.prototype.template = template;

      this.prototype.childViewContainer = '[data-behavior="post-container"]';
      this.prototype.childView = PostView;
    }

    initialize(options) {
      this.initializeFlash();
      this.vent = options.vent;
      this.submission = options.submission;
      this.collection = new DiscussionPostCollection([], {});
      this.allPosts = new DiscussionPostCollection([], {});
      this.allPosts.fetch({
        data: {submission: this.submission.id},
        success: () => {
          return this.collection.reset(this.allPosts.where({parent_id: null}));
        }
      });

      this.updateCount();

      return this.listenTo(this.allPosts, 'add sync remove', post => {
        return this.updateCount();
      });
    }

    updateCount() {
      let s;
      const l = this.allPosts.length;
      if (l === 1) {
        s = "One Comment";
      } else {
        s = `${l} Comments`;
      }
      return this.$el.find('[data-behavior="post-count"]').html(s);
    }
  };
  DiscussionView.initClass();
  return DiscussionView;
})();
