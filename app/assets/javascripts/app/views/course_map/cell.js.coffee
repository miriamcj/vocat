define ['marionette', 'hbs!templates/course_map/cell', 'models/user', 'models/group', 'models/evaluation',
], (Marionette, template, UserModel, GroupModel, EvaluationModel) ->

  class Cell extends Marionette.ItemView

    # @model = initially, a project model, but set to a submission model in the init function
    # @creator = a group or user model

    template: template

    tagName: 'td'
    className: 'clickable'

    triggers:
      'click': 'detail'
      'click [data-behavior="publish-toggle"]': 'publish:toggle'

    onDetail: () ->
      args = {
        project: @project
        creator: @creator
      }
      @vent.triggerMethod('open:detail:creator:project', args)

    onPublishToggle: () ->
      @model.toggleEvaluationPublish()

    findModel: () ->
      if @creator instanceof UserModel
        @creatorType = 'User'
      else if @creator instanceof GroupModel
        @creatorType = 'Group'

      @model = @submissions.findWhere({creator_type: @creatorType, creator_id: @creator.id, project_id: @project.id})

      if @model?
        @listenTo(@model, 'change sync', () ->
          @render()
        )
        @render()

    serializeData: () ->
      context = super()
      context.project_evaluatable = @project.evaluatable()
      context.is_active = @isActive()
      context

    isActive: () ->
      if @project.evaluatable() == false then return true
      if @model.get('current_user_has_evaluated') == true then return true
      return false

    initialize: (options) ->
      @submissions = options.submissions
      @creator = options.creator
      @vent = options.vent

      @project = @model
      @findModel()
      @listenTo(@submissions, 'reset', () ->
        @findModel()
      )
