(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/course_map/projects_item'], function(Marionette, template) {
    var CourseMapProjectsItem, _ref;

    return CourseMapProjectsItem = (function(_super) {
      __extends(CourseMapProjectsItem, _super);

      function CourseMapProjectsItem() {
        _ref = CourseMapProjectsItem.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CourseMapProjectsItem.prototype.tagName = 'li';

      CourseMapProjectsItem.prototype.template = template;

      CourseMapProjectsItem.prototype.attributes = {
        'data-behavior': 'navigate-project'
      };

      CourseMapProjectsItem.prototype.triggers = {
        'mouseover a': 'active',
        'mouseout a': 'inactive',
        'click a': 'detail'
      };

      CourseMapProjectsItem.prototype.serializeData = function() {
        var data;

        data = CourseMapProjectsItem.__super__.serializeData.call(this);
        data.courseId = this.options.courseId;
        return data;
      };

      CourseMapProjectsItem.prototype.initialize = function(options) {
        return this.$el.attr('data-project', this.model.id);
      };

      return CourseMapProjectsItem;

    })(Marionette.ItemView);
  });

}).call(this);
