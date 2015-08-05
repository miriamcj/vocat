define (require) ->
  Marionette = require('marionette')
  ProjectSubmissionRowView = require('views/project/detail/project_submission_row')
  template = require('hbs!templates/project/detail/project_submission_list')
  SubmissionCollection = require('collections/submission_for_project_collection')

  class ProjectSubmissionListView extends Marionette.CompositeView

    tagName: "table"
    className: "table"
    template: template
    childView: ProjectSubmissionRowView
    childViewContainer: "tbody"

    initialize: (options) ->
      @options = options || {}
      @projectId = Marionette.getOption(@, 'projectId')
      @collection = new SubmissionCollection([])
      @setupListeners()
      @collection.fetch({
        reset: true
        data: {project: @projectId, statistics: true}
      })

    setupListeners: () ->
      @listenTo(@collection, 'sync', () =>
        @render()
      )