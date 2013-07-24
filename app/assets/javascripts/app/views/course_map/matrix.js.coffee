define [
  'marionette',
  'hbs!templates/course_map/matrix',
  'collections/submission_collection',
  'models/evaluation'
], (
  Marionette,
  template,
  SubmissionCollection,
  EvaluationModel
) ->
  class CourseMapMatrix extends Marionette.ItemView

    template: template

    events: {
      'click .matrix--cell': 'onDetail'
      'click [data-behavior="publish-toggle"]': 'onPublishToggle'
      'mouseover .matrix--row': 'onRowActive'
      'mouseout .matrix--row': 'onRowInactive'
      'mouseover .matrix--cell': 'onColActive'
      'mouseout .matrix--cell': 'onColInactive'
    }


    onPublishToggle: (e) ->
      e.preventDefault()
      e.stopPropagation()
      $el = $(e.currentTarget)
      data = $el.data()
      console.log data
      submission = @collections.submission.get(data.submission)
      evaluationData = submission.get('current_user_evaluation')
      if evaluationData?
        evaluation = new EvaluationModel(evaluationData)
        if submission.get('current_user_evaluation_published') == true
          evaluation.save({published: false})
          submission.set('current_user_evaluation_published', false)
          @render()
        else
          evaluation.save({published: true})
          submission.set('current_user_evaluation_published', true)
          @render()

    onDetail: (e) ->
      e.preventDefault()
      $el = $(e.currentTarget)
      args = {
        project: $el.data().project
        creator: $el.closest('[data-creator]').data().creator
      }
      @vent.triggerMethod('open:detail:creator:project', args)

    onRowActive: (e) ->
      creator = $(e.currentTarget).data().creator
      @vent.triggerMethod('row:active', {creator: creator})

    onRowInactive: (e) ->
      creator = $(e.currentTarget).data().creator
      @vent.triggerMethod('row:inactive', {creator: creator})

    onColActive: (e) ->
      project = $(e.currentTarget).data().project
      @vent.triggerMethod('col:active', {project: project})

    onColInactive: (e) ->
      project= $(e.currentTarget).data().project
      @vent.triggerMethod('col:inactive', {project: project})

    onRender: () ->
      @vent.triggerMethod('repaint')

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @collections = Marionette.getOption(@, 'collections')

      @collections.submission.fetch({data: {brief: 1}})
      @collections.submission.isMatrixCollection = true

      @listenTo @collections.submission, 'sync', (name) =>
        @render()

      @listenTo @collections.submission, 'change', (name) =>
        @render()


    serializeData: () ->
      out = {
        courseId: @courseId
        creators: @collections.creator.toJSON()
        projects: @collections.project.toJSON()
        submissions: @collections.submission.toJSON()
      }


