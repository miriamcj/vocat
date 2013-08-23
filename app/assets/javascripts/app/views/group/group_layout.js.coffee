define [
  'marionette',
  'hbs!templates/group/group_layout',
  'views/abstract/sliding_grid_layout',
  'views/group/creators'
  'views/group/groups'
  'views/group/rows'
  'views/modal/modal_confirm'
], (
  Marionette, template, SlidingGridLayout, CreatorsView, GroupsView, RowsView, ModalConfirmView
) ->

  class GroupLayout extends SlidingGridLayout

    sliderVisibleColumns: 4

    isDirty: false

    template: template

    children: {}

    regions: {
      creators: '[data-region="creators"]'
      groups: '[data-region="groups"]'
      rows: '[data-region="rows"]'
    }

    events: {
    }

    triggers: {
      'click [data-trigger="add"]':   'click:group:add'
      'click [data-trigger="assign"]':   'click:group:assign'
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
      'click [data-trigger="save"]': 'click:groups:save'
    }

    ui: {
      header: '.matrix--column-header'
      dirtyMessage: '[data-behavior="dirty-message"]'
      sliderContainer: '[data-behavior="matrix-slider"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

    onClickGroupsSave: () ->
      @collections.group.save()
      @ui.dirtyMessage.slideUp()
      @isDirty = false

    onDirty: () ->
      if @isDirty == false
        @ui.dirtyMessage.slideDown()
      @isDirty = true

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
      @rows.show(@children.rows)

    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId
      @collections.group.courseId = @courseId
      @children.creators = new CreatorsView({collection: @collections.creator, courseId: @courseId, vent: @})
      @children.groups = new GroupsView({collection: @collections.group, courseId: @courseId, vent: @})
      @children.rows = new RowsView({collection: @collections.creator, collections: @collections, courseId: @courseId, vent: @})

      @listenTo(@children.groups,'after:item:added item:removed', () =>
        @sliderRecalculate()
      )

      @listenTo(@children.groups,'after:item:added', () =>
        @triggerMethod('slider:right')
      )

      setTimeout () =>
        @ui.header.stickyHeader()
      , 500



