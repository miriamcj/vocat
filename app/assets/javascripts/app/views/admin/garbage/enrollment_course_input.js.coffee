define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment_course_input')
  EnrollmentInputItemView = require('views/admin/enrollment_course_input_item')
  EnrollmentInputEmptyView = require('views/admin/enrollment_input_empty')
  EnrollmentInputNoResultsView = require('views/admin/enrollment_input_no_results')
  require('jquery_ui')
  require('vendor/plugins/ajax_chosen')

  class EnrollmentCourseInput extends Marionette.CompositeView

    template: template
    emptyView: EnrollmentInputEmptyView
    itemView: EnrollmentInputItemView
    itemViewContainer: '[data-container="items"]'
    ui: {
      studentInput: '[data-behavior="search-term"]'
    }

    triggers: {
      'keyup [data-behavior="search-term"]': 'keyUp'
    }

    initialize: () ->

    onKeyUp: () ->
      term = @ui.studentInput.val()
      if term.length >= 1
        @collection.fetch({url: "#{@collection.url()}/search", data: {section: term}})
      else
        @emptyView = EnrollmentInputNoResultsView
        @collection.reset()

    onRender: () ->
