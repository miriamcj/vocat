(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.CourseMapProjectDetail = (function(_super) {
    __extends(CourseMapProjectDetail, _super);

    function CourseMapProjectDetail() {
      _ref = CourseMapProjectDetail.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    CourseMapProjectDetail.prototype.template = HBT["app/templates/course_map/project_detail"];

    CourseMapProjectDetail.prototype.initialize = function(options) {
      this.courseId = options.courseId;
      this.project = options.project;
      this.creators = options.creators;
      this.showCourse = options.showCourse;
      return window.Vocat.Dispatcher.trigger('courseMap:childViewLoaded', this);
    };

    CourseMapProjectDetail.prototype.render = function() {
      var context;

      context = {
        creators: this.creators.toJSON(),
        project: this.project.toJSON()
      };
      this.$el.html(this.template(context));
      this.$el.find('[data-behavior="dropdown"]').dropdownNavigation();
      return this;
    };

    return CourseMapProjectDetail;

  })(Vocat.Views.AbstractView);

}).call(this);
