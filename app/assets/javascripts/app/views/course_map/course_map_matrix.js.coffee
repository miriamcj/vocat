define [
  'marionette',
  'hbs!templates/course_map/course_map_matrix',
  'collections/submission_collection'
], (
  Marionette,
  template,
  SubmissionCollection
) ->
  class CourseMapMatrix extends Marionette.ItemView

    template: template

    initialize: (options) ->
      @courseId = options.courseId
      @collections = options.collections
      @submissions = new SubmissionCollection([], {courseId: @courseId})

      $.when(@submissions.fetch({data: {brief: 1}})).then () =>
        @render()

    serializeData: () ->
      out = {
        courseId: @courseId
        creators: @collections.creator.toJSON()
        projects: @collections.project.toJSON()
        submissions: @submissions.toJSON()
      }


    onRender: () ->
      #Vocat.Dispatcher.trigger('courseMap:redraw')


