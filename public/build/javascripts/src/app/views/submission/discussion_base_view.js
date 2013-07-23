(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/discussion', 'collections/discussion_post_collection', 'models/discussion_post'], function(Marionette, template, DiscussionPostCollection, DiscussionPostModel) {
    var DiscussionView, _ref;

    return DiscussionView = (function(_super) {
      __extends(DiscussionView, _super);

      function DiscussionView() {
        _ref = DiscussionView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      DiscussionView.prototype.ui = {
        bodyInput: '[data-behavior="post-input"]',
        inputToggle: '[data-behavior="input-container"]'
      };

      DiscussionView.prototype.itemViewOptions = function() {
        return {
          allPosts: this.allPosts,
          submission: this.submission
        };
      };

      DiscussionView.prototype.onPostSave = function() {
        var parent_id, post,
          _this = this;

        if (this.model != null) {
          parent_id = this.model.id;
        } else {
          parent_id = null;
        }
        post = new DiscussionPostModel({
          submission_id: this.submission.id,
          body: this.ui.bodyInput.val(),
          published: true,
          parent_id: parent_id
        });
        return post.save({}, {
          success: function(post) {
            _this.collection.add(post);
            _this.allPosts.add(post);
            return _this.resetInput();
          }
        });
      };

      DiscussionView.prototype.onReplyClear = function() {
        return this.ui.bodyInput.val('');
      };

      DiscussionView.prototype.resetInput = function() {
        this.triggerMethod('reply:clear');
        return this.triggerMethod('reply:toggle');
      };

      return DiscussionView;

    })(Marionette.CompositeView);
  });

}).call(this);
