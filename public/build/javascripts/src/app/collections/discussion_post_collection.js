(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'models/discussion_post'], function(Backbone, DiscussionPostModel) {
    var DiscussionPostCollection, _ref;

    return DiscussionPostCollection = (function(_super) {
      __extends(DiscussionPostCollection, _super);

      function DiscussionPostCollection() {
        _ref = DiscussionPostCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      DiscussionPostCollection.prototype.model = DiscussionPostModel;

      DiscussionPostCollection.prototype.initialize = function(models, options) {
        var _this = this;

        if (options.submissionId != null) {
          this.submissionId = options.submissionId;
        }
        return this.bind('remove', function(model) {
          var children;

          if (model.id != null) {
            children = _this.where({
              'parent_id': model.id
            });
            return _.each(children, function(child) {
              return child.trigger('destroy', child, child.collection, {});
            });
          }
        });
      };

      DiscussionPostCollection.prototype.url = '/api/v1/discussion_posts';

      DiscussionPostCollection.prototype.getParentPosts = function() {
        return this.where({
          'parent_id': null
        });
      };

      DiscussionPostCollection.prototype.getChildPosts = function() {
        return this.filter(function(post) {
          return post.get('parent_id') !== null;
        });
      };

      return DiscussionPostCollection;

    })(Backbone.Collection);
  });

}).call(this);
