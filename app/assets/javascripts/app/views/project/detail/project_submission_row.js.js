define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/project/detail/project_submission_row')
  Backbone = require('backbone')

  class ProjectSubmissionRowView extends Marionette.ItemView

    tagName: "tr",
    template: template
    attributes: {
      'data-region': 'submission-row'
    }

    triggers: {
      'click': 'rowClick'
    }

    onRowClick: () ->
      typeSegment = "#{@model.get('creator_type').toLowerCase()}s"
      url = "courses/#{@model.get('course_id')}/#{typeSegment}/evaluations/creator/#{@model.get('creator_id')}/project/#{@model.get('project_id')}"
      Vocat.router.navigate(url, true)

    initialize: (options) ->
      @options = options || {}
      @vent = options.vent
