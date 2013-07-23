(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/course_map/creators_item'], function(Marionette, template) {
    var CourseMapCreatorsItem, _ref;

    return CourseMapCreatorsItem = (function(_super) {
      __extends(CourseMapCreatorsItem, _super);

      function CourseMapCreatorsItem() {
        _ref = CourseMapCreatorsItem.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CourseMapCreatorsItem.prototype.tagName = 'li';

      CourseMapCreatorsItem.prototype.template = template;

      CourseMapCreatorsItem.prototype.triggers = {
        'mouseover a': 'active',
        'mouseout a': 'inactive',
        'click a': 'detail'
      };

      CourseMapCreatorsItem.prototype.attributes = {
        'data-behavior': 'navigate-creator'
      };

      CourseMapCreatorsItem.prototype.serializeData = function() {
        var data;

        data = CourseMapCreatorsItem.__super__.serializeData.call(this);
        data.courseId = this.options.courseId;
        return data;
      };

      CourseMapCreatorsItem.prototype.initialize = function(options) {
        this.options = options || {};
        this.listenTo(this.model.collection, 'change:active', function(activeCreator) {
          if (activeCreator === this.model) {
            this.$el.addClass('selected');
            return this.$el.removeClass('active');
          } else {
            return this.$el.removeClass('selected');
          }
        });
        return this.$el.attr('data-creator', this.model.id);
      };

      return CourseMapCreatorsItem;

    })(Marionette.ItemView);
  });

}).call(this);
