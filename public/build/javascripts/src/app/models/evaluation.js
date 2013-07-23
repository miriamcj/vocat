(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    var EvaluationModel, _ref;

    return EvaluationModel = (function(_super) {
      __extends(EvaluationModel, _super);

      function EvaluationModel() {
        _ref = EvaluationModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      EvaluationModel.prototype.paramRoot = 'evaluation';

      EvaluationModel.prototype.omitAttributes = ['total_points', 'total_percentage', 'total_percentage_rounded'];

      EvaluationModel.prototype.urlRoot = "/api/v1/evaluations";

      EvaluationModel.prototype.sync = function(method, model, options) {
        var attributes,
          _this = this;

        if (options.attrs == null) {
          attributes = model.toJSON(options);
          _.each(attributes, function(value, key) {
            if (_.indexOf(_this.omitAttributes, key) !== -1) {
              return delete attributes[key];
            }
          });
          options.attrs = attributes;
        }
        return Backbone.sync(method, model, options);
      };

      EvaluationModel.prototype.initialize = function() {
        var _this = this;

        this.on('change:scores', function() {
          return _this.updateCalculatedScoreFields();
        });
        return this.updateCalculatedScoreFields();
      };

      EvaluationModel.prototype.updateCalculatedScoreFields = function() {
        var per, total,
          _this = this;

        total = 0;
        _.each(this.get('scores'), function(score) {
          return total = total + parseInt(score);
        });
        per = parseFloat(total / parseInt(this.get('points_possible'))) * 100;
        this.set('total_points', total);
        this.set('total_percentage', per);
        return this.set('total_percentage_rounded', per.toFixed(1));
      };

      return EvaluationModel;

    })(Backbone.Model);
  });

}).call(this);
