(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.CourseMapCreatorProjectDetail = (function(_super) {
    __extends(CourseMapCreatorProjectDetail, _super);

    function CourseMapCreatorProjectDetail() {
      _ref = CourseMapCreatorProjectDetail.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    CourseMapCreatorProjectDetail.prototype.template = HBT["app/templates/course_map/creator_project_detail"];

    return CourseMapCreatorProjectDetail;

  })(Vocat.Views.EvaluationDetail);

}).call(this);
