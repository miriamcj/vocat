(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/my_evaluation', 'collections/evaluation_collection', 'models/evaluation', 'models/rubric', 'views/flash/flash_messages', 'views/submission/evaluation_item', 'views/submission/evaluation_item_edit', 'views/submission/my_evaluation_empty'], function(Marionette, template, EvaluationCollection, Evaluation, Rubric, FlashMessagesView, EvaluationItem, EvaluationItemEdit, MyEvaluationEmpty) {
    var MyEvaluationDetail, _ref;

    return MyEvaluationDetail = (function(_super) {
      __extends(MyEvaluationDetail, _super);

      function MyEvaluationDetail() {
        _ref = MyEvaluationDetail.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      MyEvaluationDetail.prototype.template = template;

      MyEvaluationDetail.prototype.detailVisible = false;

      MyEvaluationDetail.prototype.itemView = EvaluationItemEdit;

      MyEvaluationDetail.prototype.emptyView = MyEvaluationEmpty;

      MyEvaluationDetail.prototype.itemViewContainer = '[data-behavior="scores-container"]';

      MyEvaluationDetail.prototype.ui = {
        toggleDetailOn: '.js-toggle-detail-on',
        toggleDetailOff: '.js-toggle-detail-off',
        flashContainer: '[data-container="flash"]'
      };

      MyEvaluationDetail.prototype.triggers = {
        'click [data-behavior="toggle-detail"]': 'detail:toggle',
        'click [data-behavior="evaluation-destroy"]': 'evaluation:destroy'
      };

      MyEvaluationDetail.prototype.onRender = function() {
        this.ui.flashContainer.append(this.flash.$el);
        return this.flash.render();
      };

      MyEvaluationDetail.prototype.onBeforeClose = function() {
        return this.flash.close();
      };

      MyEvaluationDetail.prototype.itemViewOptions = function() {
        return {
          vent: this,
          rubric: this.rubric
        };
      };

      MyEvaluationDetail.prototype.onMyEvaluationUpdated = function(data) {
        if (data.percentage != null) {
          return this.model.set('current_user_percentage', data.percentage);
        }
      };

      MyEvaluationDetail.prototype.onMyEvaluationPublished = function() {
        return this.model.set('current_user_evaluation_published', true);
      };

      MyEvaluationDetail.prototype.onMyEvaluationUnpublished = function() {
        return this.model.set('current_user_evaluation_published', false);
      };

      MyEvaluationDetail.prototype.onEvaluationNew = function() {
        var evaluation,
          _this = this;

        evaluation = new Evaluation({
          submission_id: this.model.id
        });
        return evaluation.save({}, {
          success: function() {
            _this.collection.add(evaluation);
            _this.model.set('current_user_has_evaluated', true);
            _this.model.set('current_user_percentage', 0);
            _this.model.set('current_user_evaluation_published', false);
            return _this.trigger('error:add', {
              level: 'notice',
              msg: 'Evaluation successfully created'
            });
          },
          error: function() {
            return _this.trigger('error:add', {
              level: 'error',
              msg: 'Unable to create evaluation. Perhaps you do not have permission to evaluate this submission.'
            });
          }
        });
      };

      MyEvaluationDetail.prototype.onEvaluationDestroy = function() {
        var evaluation, results,
          _this = this;

        evaluation = this.collection.at(0);
        results = confirm('Deleted evaluations cannot be recovered. Please confirm that you would like to delete your evaluation.');
        if (results === true) {
          return evaluation.destroy({
            success: function() {
              _this.model.set('current_user_has_evaluated', false);
              _this.model.set('current_user_percentage', null);
              _this.model.set('current_user_evaluation_published', null);
              console.log(_this.model);
              return _this.trigger('error:add', {
                level: 'notice',
                msg: 'Evaluation successfully deleted'
              });
            }
          });
        }
      };

      MyEvaluationDetail.prototype.serializeData = function() {
        return {
          evaluationExists: this.collection.length > 0
        };
      };

      MyEvaluationDetail.prototype.initialize = function(options) {
        this.rubric = new Rubric(options.project.get('rubric'));
        this.vent = Marionette.getOption(this, 'vent');
        this.courseId = Marionette.getOption(this, 'courseId');
        return this.flash = new FlashMessagesView({
          vent: this,
          clearOnAdd: true
        });
      };

      return MyEvaluationDetail;

    })(Marionette.CompositeView);
  });

}).call(this);
