define [
  'marionette',
  'hbs!templates/course_map/detail_creator',
  'views/portfolio/portfolio_submissions_item',
  'collections/collection_proxy',
  'collections/submission_collection'
], (
  Marionette, template, PortfolioSubmissionItem, CollectionProxy, SubmissionCollection
) ->

  class CourseMapDetailCreator extends Marionette.CompositeView

    template: template

    itemView: PortfolioSubmissionItem

    itemViewContainer: '[data-container="submission-summaries"]'

    events:
      'click [data-behavior="routable"]':  'onExecuteRoute'

    onExecuteRoute: (e) ->
      e.preventDefault()
      href = $(e.currentTarget).attr('href')
      if href
        window.Vocat.courseMapRouter.navigate(href, true)

    initialize: (options) ->

      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @projects = Marionette.getOption(@, 'projects')
      @submissions = @collection

      proxy = CollectionProxy(@collection)
      proxy.where({creator_id: @model.id, creator_type: @model.creatorType})
      @collection = proxy

      # This updates the submissions we need in our master submissions collection
      if @model.creatorType == 'User'
        @submissions.fetchByCourseAndUser(@courseId, @model.id)
      else if @model.creatorType == 'Group'
        @submissions.fetchByCourseAndGroup(@courseId, @model.id)
