(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/course_map/detail_creator', 'views/portfolio/portfolio_submissions_item', 'collections/submission_collection'], function(Marionette, template, PortfolioSubmissionItem, SubmissionCollection) {
    var CourseMapDetailCreator, _ref;

    return CourseMapDetailCreator = (function(_super) {
      __extends(CourseMapDetailCreator, _super);

      function CourseMapDetailCreator() {
        _ref = CourseMapDetailCreator.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CourseMapDetailCreator.prototype.template = template;

      CourseMapDetailCreator.prototype.itemView = PortfolioSubmissionItem;

      CourseMapDetailCreator.prototype.itemViewContainer = '[data-container="submission-summaries"]';

      CourseMapDetailCreator.prototype.events = {
        'click [data-behavior="routable"]': 'onExecuteRoute'
      };

      CourseMapDetailCreator.prototype.onExecuteRoute = function(e) {
        var href;

        e.preventDefault();
        href = $(e.currentTarget).attr('href');
        if (href) {
          return window.Vocat.courseMapRouter.navigate(href, true);
        }
      };

      CourseMapDetailCreator.prototype.initialize = function(options) {
        var collections;

        this.options = options || {};
        this.vent = Marionette.getOption(this, 'vent');
        this.courseId = Marionette.getOption(this, 'courseId');
        this.creatorId = Marionette.getOption(this, 'creatorId');
        collections = Marionette.getOption(this, 'collections');
        this.projects = collections.project;
        this.creators = collections.creator;
        this.creator = this.creators.get(this.creatorId);
        this.collection = new SubmissionCollection([], {
          courseId: this.courseId
        });
        return this.collection.fetch({
          reset: true,
          data: {
            creator: this.creatorId
          }
        });
      };

      return CourseMapDetailCreator;

    })(Marionette.CompositeView);
  });

}).call(this);
