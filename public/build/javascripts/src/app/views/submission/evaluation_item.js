(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/evaluation_item', 'vendor/plugins/simple_slider'], function(Marionette, template) {
    var ScoreItem, _ref;

    return ScoreItem = (function(_super) {
      __extends(ScoreItem, _super);

      function ScoreItem() {
        _ref = ScoreItem.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ScoreItem.prototype.template = template;

      ScoreItem.prototype.ui = {
        toggleTrigger: '[data-behavior="toggle-trigger"]',
        toggleTarget: '[data-behavior="toggle-target"]',
        scoreInputs: '[data-slider-visible]',
        scoreTotal: '[data-score-total]'
      };

      ScoreItem.prototype.triggers = {
        'click [data-behavior="toggle-trigger"]': 'detail:toggle'
      };

      ScoreItem.prototype.onShow = function() {
        return this.ui.toggleTarget.height(this.ui.toggleTarget.height()).hide();
      };

      ScoreItem.prototype.onDetailToggle = function() {
        if (this.ui.toggleTarget.is(':visible')) {
          return this.ui.toggleTarget.slideUp();
        } else {
          return this.ui.toggleTarget.slideDown();
        }
      };

      ScoreItem.prototype.onInputInvisibleChange = function(event, data) {
        var key, target, value;

        value = data.value;
        target = $(event.target);
        key = target.data().key;
        this.$el.find('[data-key="' + key + '"][data-slider-visible]').val(value);
        return this.retotal();
      };

      ScoreItem.prototype.initialize = function(options) {
        this.vent = options.vent;
        this.rubric = options.rubric;
        return this.listenTo(this.vent, 'rendered', function() {
          return alert('parent rendered');
        });
      };

      ScoreItem.prototype.serializeData = function() {
        var out;

        console.log(this.model.attributes);
        out = this.model.toJSON();
        out.rubric = this.rubric.toJSON();
        return out;
      };

      return ScoreItem;

    })(Marionette.ItemView);
  });

}).call(this);
