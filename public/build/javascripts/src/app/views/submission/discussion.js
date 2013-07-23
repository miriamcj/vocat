(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/discussion', 'collections/discussion_post_collection', 'views/submission/post', 'views/submission/discussion_base_view', 'models/discussion_post'], function(Marionette, template, DiscussionPostCollection, PostView, DiscussionBaseView, DiscussionPostModel) {
    var DiscussionView, _ref;

    return DiscussionView = (function(_super) {
      __extends(DiscussionView, _super);

      function DiscussionView() {
        _ref = DiscussionView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      DiscussionView.prototype.template = template;

      DiscussionView.prototype.triggers = {
        'click [data-behavior="post-save"]': 'post:save'
      };

      DiscussionView.prototype.itemViewContainer = '[data-behavior="post-container"]';

      DiscussionView.prototype.itemView = PostView;

      DiscussionView.prototype.initialize = function(options) {
        var _this = this;

        this.submission = options.submission;
        this.collection = new DiscussionPostCollection([], {});
        this.allPosts = new DiscussionPostCollection([], {});
        this.allPosts.fetch({
          data: {
            submission_id: this.submission.id
          },
          success: function() {
            return _this.collection.reset(_this.allPosts.where({
              parent_id: null
            }));
          }
        });
        this.updateCount();
        return this.listenTo(this.allPosts, 'add sync remove', function(post) {
          return _this.updateCount();
        });
      };

      DiscussionView.prototype.onShow = function() {};

      DiscussionView.prototype.updateCount = function() {
        return this.$el.find('[data-behavior="post-count"]').html(this.allPosts.length);
      };

      return DiscussionView;

    })(DiscussionBaseView);
  });

}).call(this);
