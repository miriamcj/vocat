(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/course_map/matrix', 'collections/submission_collection'], function(Marionette, template, SubmissionCollection) {
    var CourseMapMatrix, _ref;

    return CourseMapMatrix = (function(_super) {
      __extends(CourseMapMatrix, _super);

      function CourseMapMatrix() {
        _ref = CourseMapMatrix.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CourseMapMatrix.prototype.template = template;

      CourseMapMatrix.prototype.events = {
        'click .matrix--cell': 'onDetail',
        'mouseover .matrix--row': 'onRowActive',
        'mouseout .matrix--row': 'onRowInactive',
        'mouseover .matrix--cell': 'onColActive',
        'mouseout .matrix--cell': 'onColInactive'
      };

      CourseMapMatrix.prototype.onDetail = function(e) {
        var $el, args;

        e.preventDefault();
        $el = $(e.currentTarget);
        args = {
          project: $el.data().project,
          creator: $el.closest('[data-creator]').data().creator
        };
        return this.vent.triggerMethod('open:detail:creator:project', args);
      };

      CourseMapMatrix.prototype.onRowActive = function(e) {
        var creator;

        creator = $(e.currentTarget).data().creator;
        return this.vent.triggerMethod('row:active', {
          creator: creator
        });
      };

      CourseMapMatrix.prototype.onRowInactive = function(e) {
        var creator;

        creator = $(e.currentTarget).data().creator;
        return this.vent.triggerMethod('row:inactive', {
          creator: creator
        });
      };

      CourseMapMatrix.prototype.onColActive = function(e) {
        var project;

        project = $(e.currentTarget).data().project;
        return this.vent.triggerMethod('col:active', {
          project: project
        });
      };

      CourseMapMatrix.prototype.onColInactive = function(e) {
        var project;

        project = $(e.currentTarget).data().project;
        return this.vent.triggerMethod('col:inactive', {
          project: project
        });
      };

      CourseMapMatrix.prototype.onRender = function() {
        return this.vent.triggerMethod('repaint');
      };

      CourseMapMatrix.prototype.initialize = function(options) {
        var _this = this;

        this.options = options || {};
        this.vent = Marionette.getOption(this, 'vent');
        this.courseId = Marionette.getOption(this, 'courseId');
        this.collections = Marionette.getOption(this, 'collections');
        this.collections.submission.fetch({
          data: {
            brief: 1
          }
        });
        this.collections.submission.isMatrixCollection = true;
        this.listenTo(this.collections.submission, 'sync', function(name) {
          return _this.render();
        });
        return this.listenTo(this.collections.submission, 'change', function(name) {
          return _this.render();
        });
      };

      CourseMapMatrix.prototype.serializeData = function() {
        var out;

        return out = {
          courseId: this.courseId,
          creators: this.collections.creator.toJSON(),
          projects: this.collections.project.toJSON(),
          submissions: this.collections.submission.toJSON()
        };
      };

      return CourseMapMatrix;

    })(Marionette.ItemView);
  });

}).call(this);
