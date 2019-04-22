import { Application, AppRouter } from 'backbone.marionette';
import Backbone from 'backbone';

import Pikaday from 'pikaday';
// // import Rollbar from 'app/rollbar';
import ModalLayoutView from 'views/modal/modal_layout';
import ModalConfirmView from 'views/modal/modal_confirm';
import DropdownView from 'views/layout/dropdown';
import CourseSubheaderView from 'views/layout/course_subheader';
import FileBrowserView from 'views/layout/file_browser';
import FigureCollectionView from 'views/layout/figures_collection';
import ChosenView from 'views/layout/chosen';
import JumpNavView from 'views/layout/jump_nav';
import FileInputView from 'views/layout/file_input';
import HeaderDrawerView from 'views/layout/header_drawer';
import HeaderDrawerTriggerView from 'views/layout/header_drawer_trigger';
import NotificationLayoutView from 'views/notification/notification_layout';
import NotificationExceptionView from 'views/notification/notification_exception';
import project from 'views/course/manage/projects/project';
import manage_organization from 'views/manage/organizations/organization';
import {
  CourseController,
  ProjectController,
  AdminController,
  CourseMapController,
  GroupController,
  PageController,
  PortfolioController,
  RubricController,
  SubmissionController
} from 'controllers';

const Standalone = {
  project,
  manage_organization
};

window.Vocat = (Vocat = new Application());

Vocat.routes = {
  admin: {
    'admin/courses/:course/evaluators': 'evaluatorEnrollment',
    'admin/courses/:course/assistants': 'assistantEnrollment',
    'admin/courses/:course/creators': 'creatorEnrollment',
    'admin/users/:user/courses': 'courseEnrollment'
  },
  course: {
    'courses/:course/manage/enrollment': 'creatorEnrollment',
    'courses/:course/manage/projects': 'courseManageProjects'
  },
  coursemap: {
    'courses/:course/users/evaluations': 'userCourseMap',
    'courses/:course/groups/evaluations': 'groupCourseMap',
    'courses/:course/evaluations/assets/:asset': 'assetDetail',
    'courses/:course/users/evaluations/creator/:creator': 'userCreatorDetail',
    'courses/:course/groups/evaluations/creator/:creator': 'groupCreatorDetail',
    'courses/:course/users/evaluations/project/:project': 'userProjectDetail',
    'courses/:course/groups/evaluations/project/:project': 'groupProjectDetail',
    'courses/:course/users/evaluations/creator/:creator/project/:project': 'userSubmissionDetail',
    'courses/:course/users/evaluations/creator/:creator/project/:project/asset/:asset': 'userSubmissionDetailAsset',
    'courses/:course/groups/evaluations/creator/:creator/project/:project': 'groupSubmissionDetail',
    'courses/:course/groups/evaluations/creator/:creator/project/:project/asset/:asset': 'groupSubmissionDetailAsset'
  },
  group: {
    'courses/:course/manage/groups': 'index'
  },
  page: {
    'pages/help_dev': 'helpDev',
    'pages/modal_dev': 'modalDev'
  },
  project: {
    'courses/:course/users/project/:project': 'userProjectDetail'
  },
  rubric: {
    'courses/:course/manage/rubrics/new': 'new',
    'admin/rubrics/new': 'new',
    'rubrics/new': 'new',
    'courses/:course/manage/rubrics/:rubric/edit': 'edit',
    'admin/rubrics/:rubric/edit': 'editWithoutCourse',
    'rubrics/:rubric/edit': 'editWithoutCourse'
  },
  submission: {
    'courses/:course/users/creator/:creator/project/:project': 'creatorProjectDetail',
    'courses/:course/groups/creator/:creator/project/:project': 'groupProjectDetail',
    'courses/:course/view/project/:project': 'creatorProjectDetail',
    'courses/:course/groups/creator/:creator': 'groupDetail',
    'courses/:course/users/creator/:creator': 'creatorDetail',
    'courses/:course/assets/:asset': 'assetDetail'
  }
};

Vocat.addRegions({
  main : '#region-main',
  modal : '[data-region="modal"]'
});

if ($('[data-region="global-notifications"]').length > 0) {
  Vocat.addRegions({
    notification: '[data-region="global-notifications"]'
  });
}


Vocat.addInitializer(function() {
  // Attach views to existing dom elements
  $('[data-behavior="dropdown"]').each( (index, el) => new DropdownView({el, vent: Vocat.vent}));
  $('[data-behavior="header-drawer-trigger"]').each( (index, el) => new HeaderDrawerTriggerView(({el, vent: Vocat.vent})));
  $('[data-behavior="header-drawer"]').each( (index, el) => new HeaderDrawerView({el, vent: Vocat.vent}));
  $('[data-behavior="chosen"]').each( (index, el) => new ChosenView({el, vent: Vocat.vent}));
  $('[data-behavior="jump-nav"]').each( (index, el) => new JumpNavView({el, vent: Vocat.vent}));
  $('[data-behavior="file-input"]').each( (index, el) => new FileInputView({el, vent: Vocat.vent}));
  $('[data-standalone-view]').each( function(index, el) {
    const viewName = $(el).data().standaloneView;
    return new (Standalone[viewName])({el});
  });
  $('[data-behavior="course-subheader"]').each( (index, el) => new CourseSubheaderView({el, vent: Vocat.vent}));
  $('[data-behavior="file-browser"]').each( (index, el) => new FileBrowserView({el, vent: Vocat.vent}));
  return $('[data-behavior="date-picker"]').each( (index, el) => new Pikaday(({field: el, format: 'MM/DD/YY'})));
});

Vocat.addInitializer(function() {

  // To reduce the amount of loading in development context, we load router/controller pairs dynamically.
  // TODO: Improve this for better IE support.
  let fragment;
  const pushStateEnabled = Modernizr.history;
  Backbone.history.start({pushState: pushStateEnabled });
  if (pushStateEnabled) {
    fragment = Backbone.history.getFragment();
  } else {
    fragment = window.location.pathname.substring(1);
  }

  Backbone.history.stop();
  const regexes = {};
  let controllerName = false;
  const router = new Backbone.Router;
  _.each(Vocat.routes, function(subRoutes, routeKey) {
    if (regexes[routeKey] == null) { regexes[routeKey] = []; }
    return _.each(subRoutes, function(controllerMethod, subRoute) {
      const regex = router._routeToRegExp(subRoute);
      regexes[routeKey].push(regex);
      if (fragment.match(regex)) {
        return controllerName = routeKey;
      }
    });
  });

  if (controllerName !== false) {
    const instantiateRouter = function(Controller, controllerName) {
      const subRoutes = Vocat.routes[controllerName];
      Vocat.router = new AppRouter({
        controller: new Controller,
        appRoutes: subRoutes
      });
      Backbone.history.start({pushState: pushStateEnabled});
      if (pushStateEnabled === false) {
        return router.navigate(fragment, { trigger: true });
      }
    };

    switch (controllerName) {
      case 'course': instantiateRouter(CourseController, 'course')
      case 'project': instantiateRouter(ProjectController, 'project')
      case 'admin': instantiateRouter(AdminController, 'admin')
      case 'coursemap': instantiateRouter(CourseMapController, 'coursemap')
      case 'group': instantiateRouter(GroupController, 'group')
      case 'page': instantiateRouter(PageController, 'page')
      case 'portfolio': instantiateRouter(PortfolioController, 'portfolio')
      case 'rubric': instantiateRouter(RubricController, 'rubric')
      case 'submission': instantiateRouter(SubmissionController, 'submission')
    }
  }
});

Vocat.on('before:start', function() {

 // Setup the global notifications view
  if (this.hasOwnProperty('notification')) {
    const notification = new NotificationLayoutView({vent: Vocat.vent});
    Vocat.notification.show(notification);
  }

  // Setup the global modal view
  const modal = new ModalLayoutView({vent: this});
  Vocat.modal.show(modal);

  // Setup exception handler
  Vocat.listenTo(Vocat.vent,'exception', reason => {
    Vocat.main.reset();
    return Vocat.vent.trigger('notification:show', new NotificationExceptionView({msg: reason}));
  });

  // Handle confirmation on data-modalconfirm elements
  $('[data-modalconfirm]').each(function(index, el) {
    const $el = $(el);
    return $el.on('click', e => {
      if (!$el.hasClass('modal-blocked')) {
        e.preventDefault();
        e.stopPropagation();
        return Vocat.vent.trigger('modal:open', new ModalConfirmView({
          vent: Vocat,
          descriptionLabel: $el.attr('data-modalconfirm'),
          confirmElement: $el,
          dismissEvent: 'dismiss:publish'
        }));
      }
    });
  });

  // Announce some key events on the global channel
  const globalChannel = Backbone.Wreqr.radio.channel('global');
  return $('html').bind('click', event => globalChannel.vent.trigger('user:action', event));
});

export default Vocat;
