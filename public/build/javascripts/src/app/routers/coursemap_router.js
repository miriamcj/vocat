(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'controllers/coursemap_controller'], function(Marionette, CourseMapController) {
    var CourseMapRouter, _ref;

    return CourseMapRouter = (function(_super) {
      __extends(CourseMapRouter, _super);

      function CourseMapRouter() {
        _ref = CourseMapRouter.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CourseMapRouter.prototype.controller = new CourseMapController;

      CourseMapRouter.prototype.appRoutes = {
        'courses/:course/evaluations': 'grid',
        'courses/:course/evaluations/creator/:creator': 'creatorDetail',
        'courses/:course/evaluations/project/:project': 'projectDetail',
        'courses/:course/evaluations/creator/:creator/project/:project': 'creatorProjectDetail'
      };

      return CourseMapRouter;

    })(Marionette.AppRouter);
  });

}).call(this);
