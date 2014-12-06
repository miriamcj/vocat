define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/submission_layout')
  DiscussionView = require('views/discussion/discussion')
  EvaluationsView = require('views/submission/evaluations/evaluations_layout')
  AssetsView = require('views/assets/assets_layout')
  ModalGroupMembershipView = require('views/modal/modal_group_membership')

  class SubmissionLayout extends Marionette.LayoutView

    template: template
    children: {}
    courseMapContext: true

    triggers: {
      'click @ui.openGroupModal': 'open:groups:modal'
      'click @ui.close': 'close'
    }

    ui: {
      close: '[data-behavior="detail-close"]'
      openGroupModal: '[data-behavior="open-group-modal"]'
    }

    regions: {
      flash: '[data-region="flash"]'
      evaluations: '[data-region="submission-evaluations"]'
      discussion: '[data-region="submission-discussion"]'
      assets: '[data-region="submission-assets"]'
    }

    serializeData: () ->
      sd ={
        project: @project.toJSON()
        courseId: @courseId
        creator: @creator.toJSON()
        creatorType: @model.get('creator_type')
        isGroupProject: @model.get('creator_type') == 'Group'
      }
      sd

    onDomRefresh: () ->
      window.scrollTo(0,0)

    onOpenGroupsModal: () ->
      Vocat.vent.trigger('modal:open', new ModalGroupMembershipView({groupId: @creator.id}))

    onClose: () ->
      context = @model.get('creator_type').toLowerCase() + 's'
      url = "courses/#{@courseId}/#{context}/evaluations"
      Vocat.router.navigate(url, true)

    onShow: () ->
      unless @$el.parent().data().hasOwnProperty('hideBackLink')
        @ui.close.show()

      @discussion.show(new DiscussionView({submission: @model}))
      if @model.get('project').evaluatable
        @evaluations.show(new EvaluationsView({rubric: @rubric, project: @project, model: @model, courseId: @courseId}))
      @assets.show(new AssetsView({collection: @model.assets(), model: @model, courseId: @courseId}))

    initialize: (options) ->
      console.log options
      @options = options || {}
      @collections = {}
      @courseId = Marionette.getOption(@, 'courseId')
      @courseMapContext = Marionette.getOption(@, 'courseMapContext')
      @project = @model.project()
      @creator = @model.creator()



