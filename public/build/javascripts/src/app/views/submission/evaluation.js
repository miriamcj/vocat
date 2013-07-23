(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/evaluation', 'collections/evaluation_collection', 'models/rubric', 'views/submission/evaluation_item', 'views/submission/evaluation_item_edit', 'views/submission/evaluation_empty'], function(Marionette, template, EvaluationCollection, Rubric, EvaluationItem, EvaluationItemEdit, EvaluationEmpty) {
    var EvaluationDetailScore, _ref;

    return EvaluationDetailScore = (function(_super) {
      __extends(EvaluationDetailScore, _super);

      function EvaluationDetailScore() {
        _ref = EvaluationDetailScore.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      EvaluationDetailScore.prototype.template = template;

      EvaluationDetailScore.prototype.detailVisible = false;

      EvaluationDetailScore.prototype.itemView = EvaluationItem;

      EvaluationDetailScore.prototype.getItemView = function(item) {
        if (item.get('current_user_is_owner') === true) {
          return EvaluationItemEdit;
        } else {
          return EvaluationItem;
        }
      };

      EvaluationDetailScore.prototype.itemViewOptions = function() {
        return {
          vent: this,
          rubric: this.rubric
        };
      };

      EvaluationDetailScore.prototype.emptyView = EvaluationEmpty;

      EvaluationDetailScore.prototype.itemViewContainer = '[data-behavior="scores-container"]';

      EvaluationDetailScore.prototype.ui = {
        toggleDetailOn: '.js-toggle-detail-on',
        toggleDetailOff: '.js-toggle-detail-off'
      };

      EvaluationDetailScore.prototype.triggers = {
        'click [data-behavior="toggle-detail"]': 'detail:toggle'
      };

      EvaluationDetailScore.prototype.serializeData = function() {
        return {
          evaluationExists: this.collection.length > 0
        };
      };

      EvaluationDetailScore.prototype.initialize = function(options) {
        this.rubric = new Rubric(options.project.get('rubric'));
        this.vent = Marionette.getOption(this, 'vent');
        return this.courseId = Marionette.getOption(this, 'courseId');
      };

      return EvaluationDetailScore;

    })(Marionette.CompositeView);
  });

}).call(this);
