(function() {
  define(['marionette', 'backbone', 'controllers/global_flash_controller', 'routers/portfolio_router', 'routers/coursemap_router', 'routers/submission_router'], function(Marionette, Backbone, GlobalFlashController, PortfolioRouter, CourseMapRouter, SubmissionRouter) {
    var Vocat, globalFlashController;

    window.Vocat = Vocat = new Marionette.Application();
    Vocat.addRegions({
      main: '#region-main',
      globalFlash: '#global-flash'
    });
    Vocat.addInitializer(function() {
      Vocat.portfolioRouter = new PortfolioRouter();
      Vocat.courseMapRouter = new CourseMapRouter();
      Vocat.submissionRouter = new SubmissionRouter();
      return Backbone.history.start({
        pushState: true
      });
    });
    globalFlashController = new GlobalFlashController;
    globalFlashController.show();
    return Vocat;
  });

}).call(this);
