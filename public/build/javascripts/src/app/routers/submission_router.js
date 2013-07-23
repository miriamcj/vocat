(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'controllers/submission_controller'], function(Marionette, SubmissionController) {
    var SubmissionRouter, _ref;

    return SubmissionRouter = (function(_super) {
      __extends(SubmissionRouter, _super);

      function SubmissionRouter() {
        _ref = SubmissionRouter.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      SubmissionRouter.prototype.controller = new SubmissionController;

      SubmissionRouter.prototype.appRoutes = {
        'courses/:course/view/creator/:creator/project/:project': 'creatorProjectDetail',
        'pages/help_dev': 'helpDev'
      };

      return SubmissionRouter;

    })(Marionette.AppRouter);
  });

}).call(this);
