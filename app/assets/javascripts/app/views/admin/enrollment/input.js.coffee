define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment_user_input')
  ItemView = require('views/admin/enrollment/input_item')
  EmptyView = require('views/admin/enrollment/input_empty')
  NoResultsView = require('views/admin/enrollment/input_no_results')
  require('jquery_ui')
  require('vendor/plugins/ajax_chosen')

  class EnrollmentUserInput extends Marionette.CompositeView

    template: template
    emptyView: EmptyView
    itemView: ItemView

    itemViewContainer: '[data-container="items"]'
    ui: {
      studentInput: '[data-behavior="search-term"]'
    }

    triggers: {
      'keyup [data-behavior="search-term"]': 'keyUp'
    }

    initialize: () ->

    onKeyUp: () ->
      term = @ui.studentInput.val()
      if term.length >= 1
        data = {}
        data[@collection.getSearchTerm()] = term
        @collection.fetch({url: "#{@collection.url}/search", data: data})
      else
        @emptyView = NoResultsView
        @collection.reset()

    onRender: () ->
