define ['marionette', 'hbs!templates/course_map/publisher', 'views/modal/modal_confirm'], (Marionette, template, ModalConfirmView) ->

  class PublisherView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'matrix--cell matrix--meta-nav--cell'
    allPublished: null
    totalSubmissions: null

    ui: {
      publisher: '[data-behavior="publisher"]'
      unpublisher: '[data-behavior="unpublisher"]'
    }

    triggers: {
      'click [data-behavior="publisher"]': 'click:publish'
      'click [data-behavior="unpublisher"]': 'click:unpublish'
    }

    onClickPublish: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: "All of your evaluations for \"#{@model.get('name')}\" will be visible to students in the course. Are you sure you want to do this?",
        confirmEvent: 'confirm:publish',
        dismissEvent: 'dismiss:publish'
      }))

    onClickUnpublish: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: "All of your evaluations for \"#{@model.get('name')}\" will no longer be visible to students in the course. Are you sure you want to do this?",
        confirmEvent: 'confirm:unpublish',
        dismissEvent: 'dismiss:unpublish'
      }))

    onConfirmPublish: () ->
      submissions = @getUnpublishedSubmissions()
      _.each(submissions, (submission) =>
        submission.publishEvaluation()
      )
      @checkAllUnpublished()

    onConfirmUnpublish: () ->
      submissions = @getPublishedSubmissions()
      _.each(submissions, (submission) =>
        submission.unpublishEvaluation()
      )
      @checkAllUnpublished()

    setActionPublish: () ->
      @ui.unpublisher.hide()
      @ui.publisher.show()

    setActionNone: () ->
      @ui.unpublisher.hide()
      @ui.publisher.hide()

    setActionUnpublish: () ->
      @ui.publisher.hide()
      @ui.unpublisher.show()

    onChangeAllPublished: () ->
      if @totalSubmissions > 0
        if @allPublished == true
          @setActionUnpublish()
        else
          @setActionPublish()
      else
        @setActionNone()

    getTotalSubmissions: () ->
      @submissions.where({project_id: @model.id, creator_type: @creatorType, current_user_has_evaluated: true})

    getPublishedSubmissions: () ->
      @submissions.where({project_id: @model.id, creator_type: @creatorType, current_user_has_evaluated: true, current_user_evaluation_published: true})

    getUnpublishedSubmissions: () ->
      @submissions.where({project_id: @model.id, creator_type: @creatorType, current_user_has_evaluated: true, current_user_evaluation_published: false})

    checkAllUnpublished: () ->
      totalSubmissions = @getTotalSubmissions().length
      @totalSubmissions = totalSubmissions
      publishedSubmissions = @getPublishedSubmissions().length
      @allPublished = (totalSubmissions == publishedSubmissions)
      @triggerMethod('change:all:published')

    onRender: () ->
      @checkAllUnpublished()

    initialize: (options) ->
      @submissions = options.submissions
      @creatorType = options.creatorType
      @listenTo(@submissions, 'reset sync change:current_user_evaluation_published', (model) =>
        if model? && model.get? && model.get('project_id')? && model.get('project_id') != @model.id
          # Skip it!
        else
          @checkAllUnpublished(model)
      )
      @vent = options.vent
