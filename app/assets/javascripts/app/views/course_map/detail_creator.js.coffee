define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/course_map/detail_creator')
  PortfolioSubmissionItem = require('views/portfolio/portfolio_submissions_item')
  CollectionProxy = require('collections/collection_proxy')
  SubmissionCourseUserCollection = require('collections/submission_for_course_user_collection')
  SubmissionGroupCollection = require('collections/submission_for_group_collection')
  ModalGroupMembershipView = require('views/modal/modal_group_membership')

  class CourseMapDetailCreator extends Marionette.CompositeView

    template: template
    standalone: false
    childView: PortfolioSubmissionItem
    vent: Vocat.vent

    childViewContainer: '[data-container="submission-summaries"]'
    childViewOptions: () ->
      {
        standalone: @standalone
        creator: @model
      }

    triggers: () ->
      t = {
        'click @ui.openGroupModal': 'open:groups:modal'
      }
      if @standalone != true
        t['click [data-behavior="detail-close"]'] = 'close'
      t

    ui: {
      loadIndicator: '[data-behavior="load-indicator"]'
      openGroupModal: '[data-behavior="open-group-modal"]'
    }

    onExecuteRoute: (e) ->
      e.preventDefault()
      href = $(e.currentTarget).attr('href')
      if href
        window.Vocat.router.navigate(href, true)

    onOpenGroupsModal: () ->
      Vocat.vent.trigger('modal:open', new ModalGroupMembershipView({groupId: @model.id}))

    onClose: () ->
      segment = ''
      if @model.creatorType == 'User' then segment = 'users'
      if @model.creatorType == 'Group' then segment = 'groups'
      url = "courses/#{@courseId}/#{segment}/evaluations"
      Vocat.router.navigate(url, true)

    initialize: (options) ->
      @options = options || {}
      @standalone = Marionette.getOption(@, 'standalone')
      @courseId = Marionette.getOption(@, 'courseId')
      if @model.creatorType == 'User'
        @collection.fetch({data: {course: @courseId, user: @model.id}})
      else
        @collection.fetch({data: {group: @model.id}, success: () ->
        })

      @listenTo(@collection, 'sync', () =>
        @ui.loadIndicator.hide()
      )

    serializeData: () ->
      data = super()
      data['creatorType'] = @model.creatorType
      data['courseId'] = @courseId
      data
