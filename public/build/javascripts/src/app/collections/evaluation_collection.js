(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone', 'marionette', 'models/evaluation'], function(Backbone, Marionette, EvaluationModel) {
    var EvaluationCollection, _ref;

    return EvaluationCollection = (function(_super) {
      __extends(EvaluationCollection, _super);

      function EvaluationCollection() {
        _ref = EvaluationCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      EvaluationCollection.prototype.model = EvaluationModel;

      EvaluationCollection.prototype.initialize = function(models, options) {
        this.options = options;
        return this.courseId = Marionette.getOption(this, 'courseId');
      };

      EvaluationCollection.prototype.url = function() {
        return "/api/v1/courses/" + this.courseId + "/evaluations";
      };

      return EvaluationCollection;

    })(Backbone.Collection);
  });

}).call(this);
