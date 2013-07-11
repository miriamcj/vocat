define [
  'marionette', 'hbs!templates/course_map/detail_creator', 'views/portfolio/portfolio_submissions_item', 'collections/submission_collection'
], (
  Marionette, template, PortfolioSubmissionItem, SubmissionCollection
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
      @creatorId = Marionette.getOption(@, 'creatorId')
      collections = Marionette.getOption(@, 'collections')
      @projects = collections.project
      @creators = collections.creator
      @creator = @creators.get(@creatorId)
      @collection = new SubmissionCollection([],{courseId: @courseId})
      @collection.fetch({reset: true, data: {creator: @creatorId}})

