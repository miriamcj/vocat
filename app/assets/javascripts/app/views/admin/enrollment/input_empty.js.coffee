define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment/input_empty')

  class EnrollmentInputEmpty extends Marionette.ItemView

    template: template
    tagName: 'li'

    initialize: (options) ->
      @collectionType = options.collectionType

    serializeData: ->
      {
        isUserCollection: @collectionType == 'user'
        isCourseCollection: @collectionType == 'course'
      }

