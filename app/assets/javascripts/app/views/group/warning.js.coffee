define (require) ->

  template = require('hbs!templates/group/warning')

  class Warning extends Marionette.ItemView

    template: template

    serializeData: () ->
      {
        courseId: Marionette.getOption(@, 'courseId')
      }