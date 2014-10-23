define (require) ->

  template = require('hbs!templates/course_map/warning')

  class Warning extends Marionette.ItemView

    template: template

    initialize: (options) ->
      console.log options,'opt'

    serializeData: () ->
      out = {
        isCreatorWarning: Marionette.getOption(@, 'warningType') == 'Creator'
        isProjectWarning: Marionette.getOption(@, 'warningType') == 'Project'
        isCreatorTypeGroup: Marionette.getOption(@, 'creatorType') == 'Group'
        isCreatorTypeUser: Marionette.getOption(@, 'creatorType') == 'User'
        creatorType: Marionette.getOption(@, 'creatorType')
        warningType: Marionette.getOption(@, 'warningType')
        courseId: Marionette.getOption(@, 'courseId')
      }
      console.log out
      out
