define (require) ->
  Marionette = require('marionette')
  ProjectSubmissionRowView = require('views/project/detail/project_submission_row')
  template = require('hbs!templates/project/detail/project_submission_list')

  class ProjectSubmissionListView extends Marionette.CompositeView

    tagName: "table"
    className: "table project-details-table"
    template: template
    childView: ProjectSubmissionRowView
    childViewContainer: "tbody"

    childViewOptions: () -> {
      vent: @vent
    }

    initialize: (options) ->
      @options = options || {}
      @vent = options.vent
      @projectId = Marionette.getOption(@, 'projectId')
      @projectType = Marionette.getOption(@, 'projectType')