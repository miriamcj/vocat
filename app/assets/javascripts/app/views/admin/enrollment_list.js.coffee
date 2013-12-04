define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment_list')
  EnrollmentItem = require('views/admin/enrollment_item')
  require('jquery_ui')
  require('vendor/plugins/ajax_chosen')

  class CreatorEnrollment extends Marionette.CompositeView

    template: template

    itemViewContainer: "tbody",

    itemView: EnrollmentItem

    itemViewOptions: () ->
      {
        vent: @vent
      }

    ui: {
      studentInput: '[data-behavior="student-input"]'
    }

    initialize: (options) ->
      @vent = options.vent
      @collection.fetch()
