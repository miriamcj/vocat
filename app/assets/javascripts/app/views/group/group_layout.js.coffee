define [
  'marionette',
  'hbs!templates/group/group_layout',
  'views/abstract/sliding_grid_layout',
  'views/group/creators'
  'views/group/groups'
  'views/group/rows'

], (
  Marionette, template, SlidingGridLayout, CreatorsView, GroupsView, RowsView
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
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
      'click [data-trigger="save"]': 'click:groups:save'
    }

    ui: {
      dirtyMessage: '[data-behavior="dirty-message"]'
      sliderContainer: '[data-behavior="matrix-slider"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

    onClickGroupsSave: () ->
      @collections.group.save()

    onDirty: () ->
      if @isDirty == false
        @ui.dirtyMessage.show()
      @isDirty = true

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
      console.log @collections.group.courseId,'cid in group'
      @children.creators = new CreatorsView({collection: @collections.creator, courseId: @courseId, vent: @})
      @children.groups = new GroupsView({collection: @collections.group, courseId: @courseId, vent: @})
      @children.rows = new RowsView({collection: @collections.creator, collections: @collections, courseId: @courseId, vent: @})

      @listenTo(@children.groups,'after:item:added item:removed', () =>
        @sliderRecalculate()
        @triggerMethod('slider:right')
      )


