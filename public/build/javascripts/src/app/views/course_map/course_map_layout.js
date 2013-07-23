(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/course_map/course_map_layout', 'views/course_map/projects', 'views/course_map/creators', 'views/course_map/matrix', 'views/course_map/detail_creator', 'views/course_map/detail_project', 'views/submission/submission_layout', 'views/course_map/header', '../../../layout/plugins'], function(Marionette, template, CourseMapProjects, CourseMapCreators, CourseMapMatrix, CourseMapDetailCreator, CourseMapDetailProject, CourseMapDetailCreatorProject, CourseMapHeader) {
    var CourseMapView, _ref;

    return CourseMapView = (function(_super) {
      __extends(CourseMapView, _super);

      function CourseMapView() {
        _ref = CourseMapView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      CourseMapView.prototype.children = {};

      CourseMapView.prototype.template = template;

      CourseMapView.prototype.sliderColWidth = 200;

      CourseMapView.prototype.sliderWidth = 3000;

      CourseMapView.prototype.sliderMinLeft = 0;

      CourseMapView.prototype.sliderPosition = 0;

      CourseMapView.prototype.ui = {
        courseMapHeader: '.matrix--column-header',
        header: '[data-region="overlay-header"]',
        overlay: '[data-region="overlay"]',
        sliderLeft: '[data-behavior="matrix-slider-left"]',
        sliderRight: '[data-behavior="matrix-slider-right"]'
      };

      CourseMapView.prototype.triggers = {
        'click [data-behavior="matrix-slider-left"]': 'slider:left',
        'click [data-behavior="matrix-slider-right"]': 'slider:right'
      };

      CourseMapView.prototype.regions = {
        creators: '[data-region="creators"]',
        projects: '[data-region="projects"]',
        matrix: '[data-region="matrix"]',
        header: '[data-region="overlay-header"]',
        overlay: '[data-region="overlay"]'
      };

      CourseMapView.prototype.onRender = function() {
        var _this = this;

        this.creators.show(this.children.creators);
        this.projects.show(this.children.projects);
        this.matrix.show(this.children.matrix);
        this.updateSliderControls();
        this.header.show(this.children.header);
        this.bindUIElements();
        return setTimeout(function() {
          return _this.ui.courseMapHeader.stickyHeader();
        }, 500);
      };

      CourseMapView.prototype.initialize = function(options) {
        this.collections = options.collections;
        this.courseId = options.courseId;
        this.listenTo(this.overlay, 'show', function() {
          return this.onOpenOverlay();
        });
        this.listenTo(this.header, 'show', function() {
          return this.onOpenHeader();
        });
        this.children.creators = new CourseMapCreators({
          collection: this.collections.creator,
          courseId: this.courseId,
          vent: this
        });
        this.children.projects = new CourseMapProjects({
          collection: this.collections.project,
          courseId: this.courseId,
          vent: this
        });
        this.children.matrix = new CourseMapMatrix({
          collections: this.collections,
          courseId: this.courseId,
          vent: this
        });
        return this.children.header = new CourseMapHeader({
          collections: this.collections,
          courseId: this.courseId,
          vent: this
        });
      };

      CourseMapView.prototype.onOpenDetailCreator = function(args) {
        var view;

        this.collections.creator.setActive(args.creator);
        this.collections.project.setActive(null);
        Vocat.courseMapRouter.navigate("courses/" + this.courseId + "/evaluations/creator/" + args.creator);
        view = new CourseMapDetailCreator({
          collections: _.clone(this.collections),
          courseId: this.courseId,
          vent: this,
          creatorId: args.creator
        });
        return this.overlay.show(view);
      };

      CourseMapView.prototype.onOpenDetailProject = function(args) {
        var view;

        this.collections.project.setActive(args.project);
        this.collections.creator.setActive(null);
        Vocat.courseMapRouter.navigate("courses/" + this.courseId + "/evaluations/project/" + args.project);
        view = new CourseMapDetailProject({
          collections: _.clone(this.collections),
          courseId: this.courseId,
          vent: this,
          projectId: args.project
        });
        return this.overlay.show(view);
      };

      CourseMapView.prototype.onOpenDetailCreatorProject = function(args) {
        var view;

        this.collections.creator.setActive(args.creator);
        this.collections.project.setActive(args.project);
        Vocat.courseMapRouter.navigate("courses/" + this.courseId + "/evaluations/creator/" + args.creator + "/project/" + args.project);
        view = new CourseMapDetailCreatorProject({
          collections: _.clone(this.collections),
          courseId: this.courseId,
          vent: this,
          creator: this.collections.creator.getActive(),
          project: this.collections.project.getActive()
        });
        return this.overlay.show(view);
      };

      CourseMapView.prototype.onRowInactive = function(args) {
        return this.$el.find('[data-creator="' + args.creator + '"]').removeClass('active');
      };

      CourseMapView.prototype.onRowActive = function(args) {
        return this.$el.find('[data-creator="' + args.creator + '"]').addClass('active');
      };

      CourseMapView.prototype.onColActive = function(args) {};

      CourseMapView.prototype.onColInactive = function(args) {};

      CourseMapView.prototype.onRepaint = function() {
        this.setContentContainerHeight();
        return this.calculateAndSetSliderWidth();
      };

      CourseMapView.prototype.onShow = function() {
        return this.onRepaint();
      };

      CourseMapView.prototype.onSliderLeft = function() {
        return this.slide('backwards');
      };

      CourseMapView.prototype.onSliderRight = function() {
        return this.slide('forward');
      };

      CourseMapView.prototype.onOpenOverlay = function() {
        this.ui.overlay.css({
          top: '8rem',
          zIndex: 250,
          position: 'absolute',
          minHeight: this.matrix.$el.outerHeight()
        });
        if (!this.ui.overlay.is(':visible')) {
          this.ui.overlay.fadeIn(500);
        }
        if (!this.ui.header.is(':visible')) {
          return this.ui.header.fadeIn(500);
        }
      };

      CourseMapView.prototype.onOpenHeader = function() {};

      CourseMapView.prototype.onCloseOverlay = function(args) {
        var _this = this;

        this.matrix.$el.css({
          visibility: 'visible'
        });
        this.collections.project.setActive(null);
        this.collections.creator.setActive(null);
        Vocat.courseMapRouter.navigate("courses/" + this.courseId + "/evaluations");
        if (this.ui.overlay.is(':visible')) {
          this.ui.overlay.fadeOut(500, function() {});
        }
        if (this.ui.header.is(':visible')) {
          return this.ui.header.fadeOut(500, function() {});
        }
      };

      CourseMapView.prototype.setContentContainerHeight = function() {};

      CourseMapView.prototype.calculateAndSetSliderWidth = function() {
        var colCount, slider;

        slider = this.$el.find('[data-behavior="matrix-slider"]').first();
        colCount = slider.find('li').length;
        this.sliderWidth = colCount * this.sliderColWidth;
        this.sliderMinLeft = (this.sliderWidth * -1) + (this.sliderColWidth * 4);
        return this.$el.find('[data-behavior="matrix-slider"] ul').width(this.sliderWidth);
      };

      CourseMapView.prototype.updateSliderControls = function() {
        if ((this.sliderColWidth * 4) < this.sliderWidth) {
          if (this.sliderPosition === 0) {
            this.ui.sliderLeft.addClass('inactive');
          } else {
            this.ui.sliderLeft.removeClass('inactive');
          }
          if (this.sliderPosition === this.sliderMinLeft) {
            return this.ui.sliderRight.addClass('inactive');
          } else {
            return this.ui.sliderRight.removeClass('inactive');
          }
        } else {
          this.ui.sliderLeft.addClass('inactive');
          return this.ui.sliderRight.addClass('inactive');
        }
      };

      CourseMapView.prototype.slide = function(direction) {
        var newLeft, travel;

        if (direction === 'forward') {
          travel = this.sliderColWidth * -1;
        } else {
          travel = this.sliderColWidth * 1;
        }
        newLeft = this.sliderPosition + travel;
        if (newLeft <= 0 && newLeft >= this.sliderMinLeft) {
          this.$el.find('[data-behavior="matrix-slider"] ul').css('left', newLeft);
          this.sliderPosition = newLeft;
        }
        return this.updateSliderControls();
      };

      return CourseMapView;

    })(Marionette.Layout);
  });

}).call(this);
