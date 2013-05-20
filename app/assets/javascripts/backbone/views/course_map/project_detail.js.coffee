class Vocat.Views.CourseMapProjectDetail extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/course_map/project_detail"]

  initialize: (options) ->
    @courseId = options.courseId
    @project = options.project
    @creators = options.creators
    @showCourse = options.showCourse
    window.Vocat.Dispatcher.trigger('courseMap:childViewLoaded', @)

  render: () ->
    context = {
      creators: @creators.toJSON()
      project: @project.toJSON()
    }
    @$el.html(@template(context))

    @$el.find('[data-behavior="dropdown"]').dropdownNavigation()



    # Return thyself!!
    @