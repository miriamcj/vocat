define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/group/group_layout')
  AbstractMatrix = require('views/abstract/abstract_matrix')
  CreatorsView = require('views/group/creators')
  GroupsView = require('views/group/groups')
  ModalConfirmView = require('views/modal/modal_confirm')
  GroupMatrixView = require('views/group/matrix')
  SaveNotifyView = require('views/group/save_notify')
  WarningView = require('views/group/warning')
  GroupWarningView = require('views/group/group_warning')

  class GroupLayout extends AbstractMatrix

    warningVisible: false
    template: template

    children: {}
    stickyHeader: false
    regions: {
      creators: '[data-region="creators"]'
      groups: '[data-region="groups"]'
      matrix: '[data-region="matrix"]'
      warning: '[data-region="warning"]'
    }

    events: {
    }

    triggers: {
      'click [data-trigger="add"]': 'click:group:add'
      'click [data-trigger="assign"]': 'click:group:assign'
      'click [data-behavior="matrix-slider-left"]': 'slider:left'
      'click [data-behavior="matrix-slider-right"]': 'slider:right'
    }

    ui: {
      header: '.matrix--column-header'
      dirtyMessage: '[data-behavior="dirty-message"]'
      sliderContainer: '[data-behavior="matrix-slider"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
      hideOnWarning: '[data-behavior="hide-on-warning"]'
    }

    onDirty: () ->
      Vocat.vent.trigger('notification:show', new SaveNotifyView({collection: @collections.group}))

    onClickGroupAssign: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Each student will be randomly assigned to one group. If you proceed, students will lose their current group assignments.',
        confirmEvent: 'confirm:assign',
        dismissEvent: 'dismiss:assign'
      }))

    onConfirmAssign: () ->
      creatorIds = _.shuffle(@collections.creator.pluck('id'))
      creatorCount = creatorIds.length
      groupCount = @collections.group.length
      if groupCount > 0
        perGroup = Math.floor(creatorCount / groupCount)
        remainder = creatorCount % groupCount
        @collections.group.each((group) ->
          take = perGroup
          if remainder > 0
            take++
            remainder--
          group.set('creator_ids', creatorIds.splice(0, take))
        )
        @onDirty()

    onClickGroupAdd: () ->
      model = new @collections.group.model({name: @collections.group.getNextGroupName(), course_id: @courseId})
      model.save()
      @collections.group.add(model)


    onRender: () ->
      if @collections.creator.length == 0
        @warning.show(new WarningView({courseId: @courseId}))
        @warningVisible = true
        @ui.hideOnWarning.hide()
      if @collections.group.length == 0
        @warning.show(new GroupWarningView({courseId: @courseId, vent: @}))
        @ui.hideOnWarning.hide()
        @warningVisible = true
      else
        @creators.show(new CreatorsView({collection: @collections.creator, courseId: @courseId, vent: @}))
        @groups.show(new GroupsView({collection: @collections.group, courseId: @courseId, vent: @}))
        @matrix.show(new GroupMatrixView({
          collection: @collections.creator,
          collections: @collections,
          courseId: @courseId,
          vent: @
        }))
        @warningVisible = false

    onShow: () ->
      @parentOnShow()
      @listenTo(@collections.group, 'add', (model) =>
        index = @collections.group.indexOf(model)
        @slideToEnd()
      )
      @listenTo(@collections.group, 'add remove', () =>
        if @collections.group.length == 0
          @render()
        else if @warningVisible == true
          @render()
      )

    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId
      @collections.group.courseId = @courseId




