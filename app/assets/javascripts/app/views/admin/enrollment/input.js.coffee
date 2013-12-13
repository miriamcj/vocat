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
      termInput: '[data-behavior="search-term"]'
    }

    triggers: {
      'keyup [data-behavior="search-term"]': 'keyUp'
    }

    getTemplate: () ->
      if @collection.getSearchTerm() == 'last_name'
        usersTemplate
      else
        coursesTemplate

    initialize: () ->

    hideContainer: () ->
      @$el.find(@itemViewContainer).hide()

    showContainer: () ->
      @$el.find(@itemViewContainer).show()

    getTerm: () ->
      @ui.termInput.val()

    # TODO: Clear input if escape key is pressed.

    onKeyUp: () ->
      term = @getTerm()
      if term.length >= 1
        @showContainer()
        data = {}
        data[@collection.getSearchTerm()] = term
        @collection.fetch({url: "#{@collection.url}/search", data: data})
      else
        @hideContainer()
        @collection.reset()

    onRender: () ->
      @hideContainer()
