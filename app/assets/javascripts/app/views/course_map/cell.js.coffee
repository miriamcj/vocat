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
      @vent.trigger('navigate:submission', {submission: @model.id})

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
      if @model?
        context = super()
        context.project_evaluatable = @project.evaluatable()
        context.is_active = @isActive()
        context.is_loaded = true
      else
        context = {
          is_loaded: false
        }
      context

    isActive: () ->
      if @project.evaluatable() == false then return true
      if @model? && @model.get('current_user_has_evaluated') == true then return true
      return false

    initialize: (options) ->
      @submissions = options.submissions
      @creator = options.creator
      @vent = options.vent

      @project = @model
      @findModel()
