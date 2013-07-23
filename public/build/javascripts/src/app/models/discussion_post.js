(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    var DiscussionPostModel, _ref;

    return DiscussionPostModel = (function(_super) {
      __extends(DiscussionPostModel, _super);

      function DiscussionPostModel() {
        _ref = DiscussionPostModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      DiscussionPostModel.prototype.urlRoot = '/api/v1/discussion_posts';

      DiscussionPostModel.prototype.hasParent = function() {
        if (this.get('parent_id') != null) {
          return true;
        } else {
          return false;
        }
      };

      return DiscussionPostModel;

    })(Backbone.Model);
  });

}).call(this);
