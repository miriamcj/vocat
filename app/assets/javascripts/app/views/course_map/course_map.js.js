/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let CourseMapLayout;
  const template = require('hbs!templates/course_map/course_map_layout');
  const Backbone = require('backbone');
  const CollectionProxy = require('collections/collection_proxy');
  const CourseMapProjects = require('views/course_map/projects');
  const CourseMapCreators = require('views/course_map/creators');
  const CourseMapMatrix = require('views/course_map/matrix');
  const CourseMapDetailCreator = require('views/course_map/detail_creator');
  const WarningView = require('views/course_map/warning');
  const AbstractMatrix = require('views/abstract/abstract_matrix');

  return CourseMapLayout = (function() {
    CourseMapLayout = class CourseMapLayout extends AbstractMatrix {
      static initClass() {
  
        this.prototype.children = {};
        this.prototype.minWidth = 230;
        this.prototype.capturedScroll = 0;
        this.prototype.stickyHeader = true;
        this.prototype.template = template;
        this.prototype.creatorType = 'User';
        this.prototype.projectsView = null;
        this.prototype.creatorsView = null;
        this.prototype.matrixView = null;
  
        this.prototype.ui = {
          detail: '[data-region="detail"]',
          sliderLeft: '[data-behavior="matrix-slider-left"]',
          sliderRight: '[data-behavior="matrix-slider-right"]',
          hideOnWarning: '[data-behavior="hide-on-warning"]'
        };
  
        this.prototype.triggers = {
          'click [data-behavior="matrix-slider-left"]': 'slider:left',
          'click [data-behavior="matrix-slider-right"]': 'slider:right'
        };
  
        this.prototype.regions = {
          creators: '[data-region="creators"]',
          projects: '[data-region="projects"]',
          matrix: '[data-region="matrix"]',
          globalFlash: '[data-region="flash"]',
          warning: '[data-region="warning"]'
        };
      }

      setupListeners() {
        this.listenTo(this, 'redraw', function() {
          return this.adjustToCurrentPosition();
        });
        this.listenTo(this, 'navigate:submission', function(args) {
          return this.navigateToSubmission(args.project, args.creator);
        });
        this.listenTo(this, 'navigate:creator', function(args) {
          return this.navigateToCreator(args.creator);
        });
        return this.listenTo(this, 'navigate:project', function(args) {
          return this.navigateToProject(args.project);
        });
      }

      navigateToProject(projectId) {
        if (this.creatorType === 'User') {
          return Vocat.router.navigate(`courses/${this.courseId}/users/evaluations/project/${projectId}`, true);
        } else if (this.creatorType === 'Group') {
          return Vocat.router.navigate(`courses/${this.courseId}/groups/evaluations/project/${projectId}`, true);
        }
      }

      navigateToSubmission(projectId, creatorId) {
        const typeSegment = `${this.creatorType.toLowerCase()}s`;
        const url = `courses/${this.courseId}/${typeSegment}/evaluations/creator/${creatorId}/project/${projectId}`;
        return Vocat.router.navigate(url, true);
      }

      navigateToCreator(creatorId) {
        if (this.creatorType === 'User') {
          return Vocat.router.navigate(`courses/${this.courseId}/users/evaluations/creator/${creatorId}`, true);
        } else if (this.creatorType === 'Group') {
          return Vocat.router.navigate(`courses/${this.courseId}/groups/evaluations/creator/${creatorId}`, true);
        }
      }

      typeProxiedProjectCollection() {
        const projectType = `${this.creatorType}Project`;
        const proxiedCollection = CollectionProxy(this.collections.project);
        proxiedCollection.where(function(model) {
          const abilities = model.get('abilities');
          return (abilities.can_show_submissions === true) && ((model.get('type') === projectType) || (model.get('type') === 'OpenProject'));
        });
        return proxiedCollection;
      }

      typeProxiedCreatorCollection() {
        if (this.creatorType === 'User') {
          return this.collections.user;
        } else if (this.creatorType === 'Group') {
          return this.collections.group;
        } else {
          return new Backbone.Collection;
        }
      }

      showChildViews() {
        this.creators.show(this.creatorsView);
        this.projects.show(this.projectsView);
        this.matrix.show(this.matrixView);
        this.sliderPosition = 0;
        this.parentOnShow();
        return this.bindUIElements();
      }

      onShow() {
        if (this.projectCollection.length === 0) {
          return this.showEmptyWarning(this.creatorType, 'Project');
        } else if (this.creatorCollection.length === 0) {
          return this.showEmptyWarning(this.creatorType, 'Creator');
        } else {
          this.createChildViews();
          this.setupListeners();
          return this.showChildViews();
        }
      }

      createChildViews() {
        this.creatorsView = new CourseMapCreators({
          collection: this.creatorCollection,
          courseId: this.courseId,
          vent: this,
          creatorType: this.creatorType
        });
        this.projectsView = new CourseMapProjects({collection: this.projectCollection, courseId: this.courseId, vent: this});
        return this.matrixView = new CourseMapMatrix({
          collection: this.creatorCollection,
          collections: {project: this.projectCollection, submission: this.collections.submission},
          courseId: this.courseId,
          creatorType: this.creatorType,
          vent: this
        });
      }

      initialize(options) {
        this.collections = Marionette.getOption(this, 'collections');
        this.courseId = Marionette.getOption(this, 'courseId');
        this.creatorType = Marionette.getOption(this, 'creatorType');
        this.projectCollection = this.typeProxiedProjectCollection();
        this.creatorCollection = this.typeProxiedCreatorCollection();
        return this.collections.submission.fetch({reset: true, data: {course: this.courseId} });
      }

      showEmptyWarning(creatorType, warningType) {
        this.warning.show(new WarningView({creatorType, warningType, courseId: this.courseId}));
        return this.ui.hideOnWarning.hide();
      }

      onEvaluationsPublish(project) {
        const endpoint = `${project.url()}/publish_evaluations`;
        return $.ajax(endpoint, {
          type: 'put',
          dataType: 'json',
          data: {},
          success: (data, textStatus, jqXHR) => {
            Vocat.vent.trigger('error:add', {
              level: 'notice',
              lifetime: 4000,
              msg: `Your evaluations for ${project.get('name')} submissions have been published`
            });
            const submissions = this.collections.submission.where({project_id: project.id});
            return _.each(submissions, submission => submission.set('current_user_published', true));
          },
          error: (jqXHR, textStatus, error) => {
            return Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 4000, msg: "Unable to publish submissions."});
          }
        });
      }

      onEvaluationsUnpublish(project) {
        const endpoint = `${project.url()}/unpublish_evaluations`;
        return $.ajax(endpoint, {
          type: 'put',
          dataType: 'json',
          data: {},
          success: (data, textStatus, jqXHR) => {
            Vocat.vent.trigger('error:add', {
              level: 'notice',
              lifetime: 4000,
              msg: `Your evaluations for ${project.get('name')} submissions have been unpublished`
            });
            const submissions = this.collections.submission.where({project_id: project.id});
            return _.each(submissions, submission => submission.set('current_user_published', false));
          },
          error: (jqXHR, textStatus, error) => {
            return Vocat.vent.trigger('error:add', {level: 'notice', lifetime: 4000, msg: "Unable to unpublish submissions."});
          }
        });
      }

      serializeData() {
        const out = {
          creatorType: this.creatorType,
          hasGroupProjects: this.collections.project.hasGroupProjects(),
          hasUserProjects: this.collections.project.hasUserProjects()
        };
        return out;
      }
    };
    CourseMapLayout.initClass();
    return CourseMapLayout;
  })();
});