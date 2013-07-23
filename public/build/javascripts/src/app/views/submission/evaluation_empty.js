(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/evaluation_empty'], function(Marionette, template) {
    var ScoreEmpty, _ref;

    return ScoreEmpty = (function(_super) {
      __extends(ScoreEmpty, _super);

      function ScoreEmpty() {
        _ref = ScoreEmpty.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ScoreEmpty.prototype.template = template;

      ScoreEmpty.prototype.initialize = function(options) {
        return this.vent = options.vent;
      };

      return ScoreEmpty;

    })(Marionette.ItemView);
  });

}).call(this);
