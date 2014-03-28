define (require) ->

  Marionette = require('marionette')
  usersTemplate = require('hbs!templates/admin/enrollment/user_input')
  coursesTemplate = require('hbs!templates/admin/enrollment/course_input')
  ItemView = require('views/admin/enrollment/input_item')
  EmptyView = require('views/admin/enrollment/input_empty')
  require('jquery_ui')
  require('vendor/plugins/ajax_chosen')

  class EnrollmentUserInput extends Marionette.CompositeView

    emptyView: EmptyView

    itemView: ItemView

    itemViewContainer: '[data-container="items"]'

    ui: {
      emptyViewContainer: '[data-container="empty"]'
      termInput: '[data-behavior="search-term"]'
      showBulk: '[data-behavior="show-bulk"]'
    }

    triggers: {
      'keyup [data-behavior="search-term"]': 'keyUp'
      'click [data-behavior="show-bulk"]': 'showBulk'
    }

    initialize: (options) ->
      @collectionType = options.collectionType
      @enrollmentCollection = options.enrollmentCollection
      @listenTo(@, 'itemview:invited', (event) =>
        @ui.termInput.val('')
        @onKeyUp()
      )

    onItemviewAdd: () ->
      @ui.termInput.val('')
      @onKeyUp()

    checkCollectionLength: () ->
      if @collection.length > 0
        @showContainer()
      else
        @hideContainer()

    buildItemView: (item, ItemViewType, itemViewOptions) ->
      options = _.extend({model: item}, itemViewOptions)
      options.enrollmentCollection = @enrollmentCollection
      options.vent = @options.vent
      options.collectionType = @collectionType
      itemView = new ItemViewType(options)
      itemView

    getTemplate: () ->
      if @collection.getSearchTerm() == 'email'
        usersTemplate
      else
        coursesTemplate

    hideContainer: () ->
      @$el.find(@itemViewContainer).hide()

    showContainer: () ->
      @$el.find(@itemViewContainer).show()

    getTerm: () ->
      @ui.termInput.val().trim()

    onSubmit: () ->

    # TODO: Clear input if escape key is pressed.
    onKeyUp: _.debounce(() ->
      term = @getTerm()
      if term.length >= 1
        @showContainer()
        data = {}
        data[@collection.getSearchTerm()] = term
        @trigger('input:changed', {value: term})
        @collection.fetch({url: "#{@collection.url}/search", data: data})
      else
        @hideContainer()
        @collection.reset()
    , 250)

    onRender: () ->
      @hideContainer()
