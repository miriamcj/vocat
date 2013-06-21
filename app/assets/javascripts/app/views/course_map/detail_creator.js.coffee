define [
  'marionette', 'hbs!templates/course_map/detail_creator', 'views/portfolio/portfolio_submissions_item', 'collections/submission_collection'
], (
  Marionette, template, PortfolioSubmissionItem, SubmisssionCollection
) ->

  class CourseMapDetailCreator extends Marionette.CompositeView

    template: template

    itemView: PortfolioSubmissionItem

    itemViewContainer: '[data-container="submission-summaries"]'

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @creatorId = Marionette.getOption(@, 'creatorId')
      collections = Marionette.getOption(@, 'collections')
      @projects = collections.project
      @creators = collections.creator
      @creator = @creators.get(@creatorId)

      @collection = collections.submission
      @collection.creatorId = @creatorId
      @collection.courseId = @courseId
      @collection.projectId = null
      @collection.fetch()
