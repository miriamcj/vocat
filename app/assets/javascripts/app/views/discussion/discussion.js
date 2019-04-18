/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let DiscussionView;
  const Marionette = require('marionette');
  const template = require('hbs!templates/discussion/discussion');
  const DiscussionPostCollection = require('collections/discussion_post_collection');
  const PostView = require('views/discussion/post');
  const AbstractDiscussionView = require('views/abstract/abstract_discussion');
  const DiscussionPostModel = require('models/discussion_post');

  return DiscussionView = (function() {
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
});
