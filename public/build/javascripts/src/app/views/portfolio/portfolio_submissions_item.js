(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/portfolio/portfolio_item_submission'], function(Marionette, SubmissionTemplate) {
    var PortfolioItemSubmission, _ref;

    return PortfolioItemSubmission = (function(_super) {
      __extends(PortfolioItemSubmission, _super);

      function PortfolioItemSubmission() {
        _ref = PortfolioItemSubmission.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PortfolioItemSubmission.prototype.template = SubmissionTemplate;

      PortfolioItemSubmission.prototype.className = 'portfolio-frame';

      PortfolioItemSubmission.prototype.defaults = {
        showCourse: true,
        showCreator: true
      };

      PortfolioItemSubmission.prototype.initialize = function(options) {
        options = _.extend(this.defaults, options);
        this.showCourse = options.showCourse;
        return this.showCreator = options.showCreator;
      };

      PortfolioItemSubmission.prototype.serializeData = function() {
        var data;

        data = PortfolioItemSubmission.__super__.serializeData.call(this);
        return {
          submission: data,
          showCourse: this.showCourse,
          showCreator: this.showCreator
        };
      };

      return PortfolioItemSubmission;

    })(Marionette.ItemView);
  });

}).call(this);
