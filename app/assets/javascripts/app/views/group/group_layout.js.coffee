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

    sliderVisibleColumns: 3

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
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
    }

    ui: {
      sliderContainer: '[data-behavior="matrix-slider"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

    onRender: () ->
      @creators.show(@children.creators)
      @groups.show(@children.groups)
      @rows.show(@children.rows)

    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId
      @children.creators = new CreatorsView({collection: @collections.creator, courseId: @courseId, vent: @})
      @children.groups = new GroupsView({collection: @collections.group, courseId: @courseId, vent: @})
      @children.rows = new RowsView({collection: @collections.creator, collections: @collections, courseId: @courseId, vent: @})