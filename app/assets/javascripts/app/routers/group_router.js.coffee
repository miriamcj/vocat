define ['marionette', 'controllers/group_controller'], (Marionette, GroupController) ->

  class GroupRouter extends Marionette.AppRouter

    controller: new GroupController

    appRoutes : {
      'courses/:course/manage/groups/new': 'new'
    }
