(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/my_evaluation_empty'], function(Marionette, template) {
    var MyEvaluationEmpty, _ref;

    return MyEvaluationEmpty = (function(_super) {
      __extends(MyEvaluationEmpty, _super);

      function MyEvaluationEmpty() {
        _ref = MyEvaluationEmpty.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      MyEvaluationEmpty.prototype.template = template;

      MyEvaluationEmpty.prototype.triggers = {
        'click [data-behavior="create-evaluation"]': 'evaluation:new'
      };

      MyEvaluationEmpty.prototype.onEvaluationNew = function() {
        return this.vent.triggerMethod('evaluation:new');
      };

      MyEvaluationEmpty.prototype.initialize = function(options) {
        return this.vent = options.vent;
      };

      return MyEvaluationEmpty;

    })(Marionette.ItemView);
  });

}).call(this);
