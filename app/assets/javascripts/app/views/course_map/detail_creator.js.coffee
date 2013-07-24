define [
  'marionette', 'hbs!templates/course_map/detail_creator', 'views/portfolio/portfolio_submissions_item', 'collections/submission_collection', 'models/submission'
], (
  Marionette, template, PortfolioSubmissionItem, SubmissionCollection, SubmissionModel
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

    serializeData: () ->


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

      # This part is a little bit tricky. Requesting a single submission will always create the submission model. In this
      # case, we're looping through existing submissions, comparing them against projects for the course, and requesting a
      # submission for each project if we don't have a submission. This complicates things client-side, but it keeps things
      # somewhat simpler server-side, where we only use the find_or_create approach when a single record is requested.
      @collection.fetch({reset: true, silent: true, data: {creator: @creatorId}, success: () =>
        @projects.each (project) =>
          submission = @collection.findWhere({project_id: project.id})
          if submission?
            # Do nothing
          else
            submission = new SubmissionModel({project_id: project.id, creator_id: @creatorId, project_name: project.get('name')})
            @collection.add(submission)
            tmpCol = new SubmissionCollection([],{courseId: @courseId})
            tmpCol.fetch({data: {creator: @creatorId, project: project.id}, success: () =>
              attributes = tmpCol.first().attributes
              submission.set(attributes)
            })
          @collection.trigger('reset')
      })
