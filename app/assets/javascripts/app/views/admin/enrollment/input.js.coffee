define (require) ->

  Marionette = require('marionette')
  usersTemplate = require('hbs!templates/admin/enrollment/user_input')
  coursesTemplate = require('hbs!templates/admin/enrollment/course_input')
  ItemView = require('views/admin/enrollment/input_item')
  EmptyView = require('views/admin/enrollment/input_empty')
  ClosesOnUserAction = require('behaviors/closes_on_user_action')
  require('jquery_ui')
  require('vendor/plugins/ajax_chosen')

  class EnrollmentUserInput extends Marionette.CompositeView

    emptyView: EmptyView

    childView: ItemView

    childViewContainer: '[data-container="items"]'

    ui: {
      emptyViewContainer: '[data-container="empty"]'
      containerWrapper: '[data-behavior="container-wrapper"]'
      termInput: '[data-behavior="search-term"]'
      showBulk: '[data-behavior="show-bulk"]'
    }

    triggers: {
      'keypress [data-behavior="search-term"]': {
        event: "update"
        preventDefault: false
        stopPropagation: false
      }
      'keyup [data-behavior="search-term"]': {
        event: "update"
        preventDefault: false
        stopPropagation: false
      }

      'change [data-behavior="search-term"]': {
        event: "update"
        preventDefault: false
        stopPropagation: false
      }
      'blur [data-behavior="search-term"]': {
        event: "blur"
        preventDefault: false
        stopPropagation: false
      }
      'focus [data-behavior="search-term"]': 'focus'
      'click [data-behavior="show-bulk"]': 'showBulk'
    }

    initialize: (options) ->
      @collectionType = options.collectionType
      @enrollmentCollection = options.enrollmentCollection
      @setupListeners()


    setupListeners: () ->
      @listenTo(@, 'childview:clicked', (event) =>
        @ui.termInput.val('')
        @ui.termInput.blur()
        promise = @onUpdate()
        promise.then(() =>
          @close()
        )
      )

#    onChildviewAdd: () ->
#      @ui.termInput.val('')
#      @onUpdate()

    checkCollectionLength: () ->
      if @collection.length > 0
        @open()
      else
        @close()

    buildChildView: (item, ItemViewType, childViewOptions) ->
      options = _.extend({model: item}, childViewOptions)
      options.enrollmentCollection = @enrollmentCollection
      options.vent = @options.vent
      options.collectionType = @collectionType
      childView = new ItemViewType(options)
      childView

    getTemplate: () ->
      if @collection.getSearchTerm() == 'email'
        usersTemplate
      else
        coursesTemplate

    close: () ->
      if @ui.containerWrapper.is(':visible')
        @ui.containerWrapper.hide()
        @triggerMethod('closed')

    open: () ->
      if !@ui.containerWrapper.is(':visible')
        @ui.containerWrapper.show()
        @triggerMethod('opened')

    getTerm: () ->
      @ui.termInput.val().trim()

    onFocus: () ->
      term = @getTerm()
      if term.length >= 1
        @open()

    onBlur: () ->
      @close()
      true

    onUpdate: _.debounce(() ->
      promise = $.Deferred()
      promise.then(() =>
        if @ui.termInput.is(":focus")
          @open()
      )

      term = @getTerm()
      if term.length >= 1
        data = {}
        data[@collection.getSearchTerm()] = term
        @trigger('input:changed', {value: term})
        @collection.fetch({url: "#{@collection.url}/search", data: data, success: () =>
          promise.resolve()
        })
      else
        @collection.reset()
        promise.resolve()


      promise
    , 250)

    onShow: () ->
      @ui.containerWrapper.hide()
