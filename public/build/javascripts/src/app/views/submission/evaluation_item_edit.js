(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/evaluation_item_edit', 'vendor/plugins/simple_slider'], function(Marionette, template) {
    var ScoreItemEdit, _ref;

    return ScoreItemEdit = (function(_super) {
      __extends(ScoreItemEdit, _super);

      function ScoreItemEdit() {
        _ref = ScoreItemEdit.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ScoreItemEdit.prototype.template = template;

      ScoreItemEdit.prototype.ui = {
        scoreSliders: '[data-slider="true"]',
        scoreInputs: '[data-slider-visible]',
        scoreTotal: '[data-score-total]',
        scoreTotalPercentage: '[data-score-total-percentage]',
        publishButton: '[data-behavior="model-publish"]',
        unpublishButton: '[data-behavior="model-unpublish"]',
        saveButton: '[data-behavior="model-save"]',
        publishState: '[data-behavior="publish-state"]',
        percentageBar: '[data-behavior="percentage-bar"]'
      };

      ScoreItemEdit.prototype.events = {
        'slider:changed [data-slider="true"]': 'onInputInvisibleChange'
      };

      ScoreItemEdit.prototype.triggers = {
        'change [data-slider-visible-input]': 'input:visible:change',
        'click [data-behavior="model-publish"]': 'model:publish',
        'click [data-behavior="model-unpublish"]': 'model:unpublish',
        'click [data-behavior="model-save"]': 'model:save'
      };

      ScoreItemEdit.prototype.setUiPublishedState = function(published) {
        if (published === true) {
          this.ui.publishButton.hide();
          this.ui.unpublishButton.show();
          return this.ui.publishState.html('visible');
        } else {
          this.ui.publishButton.show();
          this.ui.unpublishButton.hide();
          return this.ui.publishState.html('hidden');
        }
      };

      ScoreItemEdit.prototype.onModelPublish = function() {
        var _this = this;

        return this.model.save({
          published: true
        }, {
          success: function() {
            _this.vent.triggerMethod('myEvaluation:published');
            _this.vent.trigger('error:add', {
              level: 'notice',
              msg: 'Evaluation has been published'
            });
            return _this.setUiPublishedState(true);
          },
          error: function() {
            return _this.vent.trigger('error:add', {
              level: 'notice',
              msg: 'Unable to update evaluation'
            });
          }
        });
      };

      ScoreItemEdit.prototype.onModelUnpublish = function() {
        var _this = this;

        return this.model.save({
          published: false
        }, {
          success: function() {
            _this.vent.triggerMethod('myEvaluation:unpublished');
            _this.vent.trigger('error:add', {
              level: 'notice',
              msg: 'Evaluation has been hidden'
            });
            return _this.setUiPublishedState(false);
          },
          error: function() {
            return _this.vent.trigger('error:add', {
              level: 'notice',
              msg: 'Unable to update evaluation'
            });
          }
        });
      };

      ScoreItemEdit.prototype.onModelSave = function() {
        var scores,
          _this = this;

        scores = this.model.get('scores');
        this.ui.scoreInputs.each(function(index, element) {
          var $el;

          $el = $(element);
          return scores[$el.attr('data-key')] = parseInt($el.val());
        });
        return this.model.save({
          scores: scores
        }, {
          success: function(model) {
            _this.model.trigger('change:scores');
            _this.vent.triggerMethod('myEvaluation:updated', {
              percentage: _this.model.get('total_percentage_rounded')
            });
            return _this.vent.trigger('error:add', {
              level: 'notice',
              msg: 'Evaluation has been successfully saved'
            });
          }
        });
      };

      ScoreItemEdit.prototype.onInputInvisibleChange = function(event, data) {
        var key, target, value;

        value = data.value;
        target = $(event.target);
        key = target.data().key;
        this.$el.find('[data-key="' + key + '"][data-slider-visible]').val(value);
        return this.retotal();
      };

      ScoreItemEdit.prototype.initialize = function(options) {
        this.vent = options.vent;
        return this.rubric = options.rubric;
      };

      ScoreItemEdit.prototype.serializeData = function() {
        var out;

        out = this.model.toJSON();
        out.rubric = this.rubric.toJSON();
        return out;
      };

      ScoreItemEdit.prototype.initializeSliders = function() {
        return this.ui.scoreSliders.each(function(index, el) {
          var $el, slider;

          $el = $(el);
          return slider = $el.simpleSlider({
            range: [0, 6],
            step: 1,
            snap: true,
            highlight: true
          });
        });
      };

      ScoreItemEdit.prototype.retotal = function() {
        var per, pointsPossible, total;

        total = 0;
        pointsPossible = this.rubric.get('points_possible');
        this.ui.scoreInputs.each(function(index, element) {
          return total = total + parseInt($(element).val());
        });
        per = parseFloat(total / pointsPossible) * 100;
        this.ui.scoreTotalPercentage.html(per.toFixed(1));
        this.ui.scoreTotal.html(total);
        return this.ui.percentageBar.css('padding-right', (100 - parseInt(per)) + '%');
      };

      ScoreItemEdit.prototype.onShow = function() {
        this.initializeSliders();
        return this.retotal();
      };

      return ScoreItemEdit;

    })(Marionette.ItemView);
  });

}).call(this);
