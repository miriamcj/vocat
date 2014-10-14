define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/group/group_layout')
  AbstractMatrix = require('views/abstract/abstract_matrix')
  CreatorsView = require('views/group/creators')
  GroupsView = require('views/group/groups')
  ModalConfirmView = require('views/modal/modal_confirm')
  GroupMatrixView = require('views/group/matrix')
  SaveNotifyView = require('views/group/save_notify')

  class GroupLayout extends AbstractMatrix

    template: template

    children: {}

    regions: {
      creators: '[data-region="creators"]'
      groups: '[data-region="groups"]'
      matrix: '[data-region="matrix"]'
    }

    events: {
    }

    triggers: {
      'click [data-trigger="add"]':   'click:group:add'
      'click [data-trigger="assign"]':   'click:group:assign'
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
    }

    ui: {
      header: '.matrix--column-header'
      dirtyMessage: '[data-behavior="dirty-message"]'
      sliderContainer: '[data-behavior="matrix-slider"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

    onDirty: () ->
      Vocat.vent.trigger('notification:show', new SaveNotifyView({collection: @collections.group}))


    onClickGroupAssign: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Each student will be randomly assigned to one group. If you proceed, students will lose their current group assignments. Are you sure you want to do this?',
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
        @collections.group.each( (group) ->
          take = perGroup
          if remainder > 0
            take++
            remainder--
          group.set('creator_ids',creatorIds.splice(0,take))
        )
        @onDirty()

    onClickGroupAdd: () ->
      model = new @collections.group.model({name: @collections.group.getNextGroupName(), course_id: @courseId})
      model.save()
      @collections.group.add(model)


    onRender: () ->
      @creators.show(@children.creators)
      @groups.show(@children.groups)
      @matrix.show(@children.matrix)

    onShow: () ->
      @parentOnShow()
      @listenTo(@collections.group, 'add', (model) =>
        index = @collections.group.indexOf(model)
        @slideToEnd()
      )


    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId
      @collections.group.courseId = @courseId
      @children.creators = new CreatorsView({collection: @collections.creator, courseId: @courseId, vent: @})
      @children.groups = new GroupsView({collection: @collections.group, courseId: @courseId, vent: @})
      @children.matrix = new GroupMatrixView({collection: @collections.creator, collections: @collections, courseId: @courseId, vent: @})



