define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/course_map/projects_item')
  DropdownView = require('views/layout/dropdown')
  ModalConfirmView = require('views/modal/modal_confirm')

  class CourseMapProjectsItem extends Marionette.ItemView

#
#    $('[data-behavior="dropdown"]').each( (index, el) ->
#        new DropdownView({el: el, vent: Vocat.vent})
#    )
#
    tagName: 'th'
    template: template
    attributes: {
      'data-behavior': 'navigate-project'
      'data-match-height-source': ''
    }

    ui: {
      dropdowns: '[data-behavior="dropdown"]'
      publishAll: '[data-behavior="publish-all"]'
      unpublishAll: '[data-behavior="unpublish-all"]'
    }

    triggers: {
      'mouseover a': 'active'
      'mouseout a': 'inactive'
      'click a':   'detail'
      'click @ui.publishAll': 'click:publish'
      'click @ui.unpublishAll': 'click:unpublish'
    }

    serializeData: () ->
      data = super()
      if @creatorType == 'Group'
        data.isGroup = true
        data.isUser = false
      if @creatorType == 'User'
        data.isGroup = false
        data.isUser = true
      data.courseId = @options.courseId
      data

    initialize: (options) ->
      @creatorType = Marionette.getOption(@, 'creatorType')
      @$el.attr('data-project', @model.id)
      @vent = options.vent

    onShow: () ->
      @ui.dropdowns.each( (index, el) ->
        new DropdownView({el: el, vent: Vocat.vent, allowAdjustment: false})
      )

    onClickPublish: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        headerLabel: "Are You Sure?"
        descriptionLabel: "If you proceed, all of your evaluations for \"#{@model.get('name')}\" will be visible to students in the course.",
        confirmEvent: 'confirm:publish',
        dismissEvent: 'dismiss:publish'
      }))

    onClickUnpublish: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        headerLabel: "Are You Sure?"
        descriptionLabel: "If you proceed, all of your evaluations for \"#{@model.get('name')}\" will no longer be visible to students in the course.",
        confirmEvent: 'confirm:unpublish',
        dismissEvent: 'dismiss:unpublish'
      }))

    onConfirmPublish: () ->
      @vent.triggerMethod('evaluations:publish', @model)

    onConfirmUnpublish: () ->
      @vent.triggerMethod('evaluations:unpublish', @model)
