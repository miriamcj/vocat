define [
  'marionette', 'hbs!templates/course_map/detail_project'
], (
  Marionette, template
) ->

  class CourseMapDetailCreator extends Marionette.CompositeView

    template: template

    itemViewContainer: '[data-container="submission-summaries"]'

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      collections = Marionette.getOption(@, 'collections')

#      @collection = collections.submission
#      @collection.creatorId = @creatorId
#      @collection.creatorId = @creator.id
#      @collection.courseId = @courseId
#      @collection.projectId = null
#      @collection.fetch()
