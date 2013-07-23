(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/post', 'collections/discussion_post_collection', 'models/discussion_post', 'views/submission/discussion_base_view'], function(Marionette, template, DiscussionPostCollection, DiscussionPostModel, DiscussionBaseView) {
    var PostView, _ref;

    return PostView = (function(_super) {
      __extends(PostView, _super);

      function PostView() {
        _ref = PostView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PostView.prototype.template = template;

      PostView.prototype.itemViewContainer = '[data-behavior="post-container"]';

      PostView.prototype.triggers = {
        'click [data-behavior="post-save"]': 'post:save',
        'click [data-behavior="toggle-reply"]': 'reply:toggle',
        'click [data-behavior="toggle-delete-confirm"]': 'confirm:delete:toggle',
        'click [data-behavior="delete"]': 'post:delete'
      };

      PostView.prototype.tagName = 'li';

      PostView.prototype.initialize = function(options) {
        this.allPosts = options.allPosts;
        this.submission = options.submission;
        this.vent = options.vent;
        this.collection = new DiscussionPostCollection([], {});
        return this.collection.reset(this.allPosts.where({
          parent_id: this.model.id
        }));
      };

      PostView.prototype.onConfirmDeleteToggle = function() {
        return this.$el.find('[data-behavior="delete-confirm"]:first').slideToggle(150);
      };

      PostView.prototype.onPostDelete = function() {
        this.allPosts.remove(this.model);
        return this.model.destroy({
          wait: true
        });
      };

      PostView.prototype.onReplyToggle = function() {
        return this.ui.inputToggle.slideToggle({
          duration: 200
        });
      };

      PostView.prototype.handleSavePost = function(e) {
        var postInput;

        if (e.keyCode === 13) {
          e.preventDefault();
          e.stopPropagation();
          postInput = $(e.currentTarget);
          return this.vent.trigger('post:save', postInput);
        }
      };

      PostView.prototype.handleDestroyedPost = function() {
        var _this = this;

        return this.$el.fadeOut(250, function() {
          return _this.remove();
        });
      };

      return PostView;

    })(DiscussionBaseView);
  });

}).call(this);
