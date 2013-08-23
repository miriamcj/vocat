define [
  'marionette',
  'hbs!templates/course_map/creator_matrix',
  'hbs!templates/course_map/group_matrix',
  'collections/submission_collection',
  'models/evaluation'
], (
  Marionette,
  creatorTemplate,
  groupTemplate
  SubmissionCollection,
  EvaluationModel
) ->
  class CourseMapMatrix extends Marionette.ItemView

    template: (serializedModel) ->
      if serializedModel.type == 'groups'
        groupTemplate(serializedModel)
      else
        creatorTemplate(serializedModel)

    ui: {
      spacerCells: '.matrix--row-spacer li'
    }

    events: {
      'click [data-behavior="matrix-cell"]': 'onDetail'
      'click [data-behavior="publish-toggle"]': 'onPublishToggle'
      'mouseover .matrix--row': 'onRowActive'
      'mouseout .matrix--row': 'onRowInactive'
      'mouseover [data-behavior="matrix-cell"]': 'onColActive'
      'mouseout [data-behavior="matrix-cell"]': 'onColInactive'
    }

    onPublishToggle: (e) ->
      e.preventDefault()
      e.stopPropagation()
      $el = $(e.currentTarget)
      data = $el.data()
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

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      @collections = Marionette.getOption(@, 'collections')
      @creatorType = Marionette.getOption(@, 'creatorType')

      @collections.submission.fetch({url: @collections.submission.url({courses: @courseId}), data: {brief: 1, creator_type: @creatorType}})
      @collections.submission.isMatrixCollection = true

      @listenTo @collections.submission, 'sync', (name) =>
        @render()

      @listenTo @collections.submission, 'change', (name) =>
        @render()

    onShow: () ->
      @vent.triggerMethod('repaint')

    onRender: () ->
      @vent.triggerMethod('repaint')


    serializeData: () ->

      spacers = []
      iter = 4 - @collections.project.length
      if iter > 0 then _(iter).times -> spacers.push({})
      {
        spacers: spacers
        creatorType: @creatorType
        courseId: @courseId
        creators: @collections.creator.toJSON()
        projects: @collections.project.toJSON()
        submissions: @collections.submission.toJSON()
      }


