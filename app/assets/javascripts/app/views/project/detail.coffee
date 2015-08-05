define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/project/detail')
  ProjectScoreOverviewView = require('views/project/detail/project_score_overview')
  ProjectSubmissionListView = require('views/project/detail/project_submission_list')
  ProjectStatisticsModel = require('models/project_statistics')
  SubmissionCollection = require('collections/submission_for_project_collection')
  CollectionProxy = require('collections/collection_proxy')
  RubricModel = require('models/rubric')
  RubricModalView = require('views/modal/modal_rubric')

  class ProjectDetail extends Marionette.LayoutView

    template: template

    regions: {
      projectScoreOverview: '[data-region="project-score-overview"]'
      projectStudentSubmissionList: '[data-region="project-student-submission-list"]'
      projectGroupSubmissionList: '[data-region="project-group-submission-list"]'
    }

    triggers: {
      'click @ui.showRubric': 'open:rubric:modal'
    }

    ui: {
      showRubric: '[data-behavior="show-rubric"]'
    }

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @creatorType = Marionette.getOption(@, 'creatorType')
      @projectType = @model.get('type')
      @projectId = Marionette.getOption(@, 'projectId') || @model.id
      @projectStatisticsModel = new ProjectStatisticsModel({id: @projectId})
      @projectStatisticsModel.fetch({reset: true})
      @collection = new SubmissionCollection([])
      @collection.fetch({
        reset: true
        data: {project: @projectId, statistics: true}
      })
      @filterLists()

    filterLists: () ->
      @groupSubmissions = new CollectionProxy(@collection)
      @groupSubmissions.where((model) ->
        model.get('creator_type') == 'Group'
      )
      @studentSubmissions = new CollectionProxy(@collection)
      @studentSubmissions.where((model) ->
        model.get('creator_type') == 'User'
      )

    renderTables: (type) ->
      if @projectType == 'UserProject'
        @projectStudentSubmissionList.show(new ProjectSubmissionListView({projectId: @model.id, collection: @studentSubmissions, vent: @}))
      else if @projectType == 'GroupProject'
        @projectGroupSubmissionList.show(new ProjectSubmissionListView({projectId: @model.id, collection: @groupSubmissions, vent: @}))
      else
        @projectStudentSubmissionList.show(new ProjectSubmissionListView({projectId: @model.id, collection: @studentSubmissions, vent: @}))
        @projectGroupSubmissionList.show(new ProjectSubmissionListView({projectId: @model.id, collection: @groupSubmissions, vent: @}))

    onOpenRubricModal: () ->
      rubric = new RubricModel(@model.get('rubric'))
      Vocat.vent.trigger('modal:open', new RubricModalView({model: rubric}))

    serializeData: () ->
      {
        project: @model.toJSON()
      }

    onShow: () ->
      @setupListeners()

    onRender: () ->
      @projectId = Marionette.getOption(@, 'projectId')
      @projectScoreOverview.show(new ProjectScoreOverviewView({model: @projectStatisticsModel}))
      @renderTables()

    setupListeners: () ->
      @listenTo(@, 'navigate:asset', (args) ->
        console.log(args)
        @navigateToAsset(args.asset, args.course)
      )

    navigateToAsset: (assetId, courseId) ->
      url = "courses/#{courseId}/assets/#{assetId}"
      Vocat.router.navigate(url, true)