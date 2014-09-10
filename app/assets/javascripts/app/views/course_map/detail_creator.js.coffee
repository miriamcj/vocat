define [
  'marionette',
  'hbs!templates/course_map/detail_creator',
  'views/portfolio/portfolio_submissions_item',
  'collections/collection_proxy',
  'collections/submission_for_course_user_collection'
  'collections/submission_for_group_collection'
], (
  Marionette, template, PortfolioSubmissionItem, CollectionProxy, SubmissionCourseUserCollection, SubmissionGroupCollection
) ->

  class CourseMapDetailCreator extends Marionette.CompositeView

    template: template

    childView: PortfolioSubmissionItem

    childViewContainer: '[data-container="submission-summaries"]'

    events:
      'click [data-behavior="routable"]':  'onExecuteRoute'

    onExecuteRoute: (e) ->
      e.preventDefault()
      href = $(e.currentTarget).attr('href')
      if href
        window.Vocat.router.navigate(href, true)

    initialize: (options) ->

      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @projects = Marionette.getOption(@, 'projects')

      if @model.creatorType == 'User'
        @collection = new SubmissionCourseUserCollection
        @collection.fetch({data: {course: @courseId, user: @model.id}})
      else
        @collection = new SubmissionGroupCollection
        @collection.fetch({data: {group: @model.id}})
