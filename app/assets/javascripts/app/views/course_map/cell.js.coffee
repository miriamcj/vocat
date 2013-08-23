define ['marionette', 'hbs!templates/course_map/cell', 'models/user', 'models/group', 'models/evaluation',
], (Marionette, template, UserModel, GroupModel, EvaluationModel) ->

  class Cell extends Marionette.ItemView

    # @model = initially, a project model, but set to a submission model in the init function
    # @creator = a group or user model

    template: template

    tagName: 'li'
    className: 'matrix--cell'

    triggers:
      'click': 'detail'
      'click [data-behavior="publish-toggle"]': 'publish:toggle'
      'mouseover .matrix--row': 'row:active'
      'mouseout .matrix--row': 'row:inactive'
      'mouseover [data-behavior="matrix-cell"]': 'col:active'
      'mouseout [data-behavior="matrix-cell"]': 'col:inactive'

    onDetail: () ->
      args = {
        project: @project
        creator: @creator
      }
      @vent.triggerMethod('open:detail:creator:project', args)

    onPublishToggle: () ->
      evaluationData = @model.get('current_user_evaluation')
      if evaluationData?
        evaluation = new EvaluationModel(evaluationData)
        if @model.get('current_user_evaluation_published') == true
          evaluation.save({published: false})
          @model.set('current_user_evaluation_published', false)
        else
          evaluation.save({published: true})
          @model.set('current_user_evaluation_published', true)
        @render()

    findModel: () ->
      if @creator instanceof UserModel
        @creatorType = 'User'
      else if @creator instanceof GroupModel
        @creatorType = 'Group'

      @model = @submissions.findWhere({creator_type: @creatorType, creator_id: @creator.id, project_id: @project.id})
      if @model?
        @listenTo(@model, 'change', () ->
          @render()
        )
        @render()

    initialize: (options) ->
      @submissions = options.submissions
      @creator = options.creator
      @vent = options.vent
      @project = @model
      @findModel()

      @listenTo(@submissions, 'sync', () ->
        @findModel()
      )
