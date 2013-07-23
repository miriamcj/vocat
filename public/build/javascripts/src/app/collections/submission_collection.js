(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'backbone', 'models/submission'], function(Marionette, Backbone, SubmissionModel) {
    var SubmissionCollection, _ref;

    return SubmissionCollection = (function(_super) {
      __extends(SubmissionCollection, _super);

      function SubmissionCollection() {
        _ref = SubmissionCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      SubmissionCollection.prototype.model = SubmissionModel;

      SubmissionCollection.prototype.initialize = function(models, options) {
        this.options = options;
        return this.courseId = Marionette.getOption(this, 'courseId');
      };

      SubmissionCollection.prototype.url = function() {
        return "/api/v1/courses/" + this.courseId + "/submissions";
      };

      return SubmissionCollection;

    })(Backbone.Collection);
  });

}).call(this);
