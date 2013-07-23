(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.CourseMapCreatorDetail = (function(_super) {
    __extends(CourseMapCreatorDetail, _super);

    function CourseMapCreatorDetail() {
      _ref = CourseMapCreatorDetail.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    CourseMapCreatorDetail.prototype.template = HBT["app/templates/course_map/creator_detail"];

    CourseMapCreatorDetail.prototype.initialize = function(options) {
      var _this = this;

      this.courseId = options.courseId;
      this.projects = options.projects;
      this.creators = options.creators;
      this.showCourse = options.showCourse;
      this.creator = this.creators.get(options.creator);
      this.submissions = new Vocat.Collections.Submission([], {
        creatorId: this.creator.id,
        courseId: this.courseId
      });
      return $.when(this.submissions.fetch()).then(function() {
        _this.render();
        return window.Vocat.Dispatcher.trigger('courseMap:childViewLoaded', _this);
      });
    };

    CourseMapCreatorDetail.prototype.render = function() {
      var childContainer, context,
        _this = this;

      context = {
        creator: this.creator.toJSON(),
        courseId: this.courseId,
        projects: this.projects.toJSON(),
        submissions: this.submissions.toJSON()
      };
      this.$el.html(this.template(context));
      childContainer = this.$el.find('[data-behavior="submission-summaries"]');
      return this.projects.each(function(project) {
        var childView, submission;

        submission = _this.submissions.where({
          project_id: project.id
        })[0];
        if (submission == null) {
          submission = new Vocat.Models.Submission({
            project_name: project.get('name'),
            project_id: project.id,
            creator_id: _this.creator.id,
            creator_name: _this.creator.get('name'),
            course_id: project.get('course_id'),
            course_name: project.get('course_name'),
            course_name_long: project.get('course_name_long')
          });
        }
        childView = new Vocat.Views.PortfolioSubmissionSummary({
          showCourse: false,
          showCreator: false,
          el: $('<div class="constrained-portfolio-frame"></div>'),
          model: submission
        });
        return childContainer.append(childView.render());
      });
    };

    return CourseMapCreatorDetail;

  })(Vocat.Views.AbstractView);

}).call(this);
