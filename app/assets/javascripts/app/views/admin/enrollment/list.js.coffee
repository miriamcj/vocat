define (require) ->

  Marionette = require('marionette')
  ItemView = require('views/admin/enrollment/item')
  EmptyCoursesView = require('views/admin/enrollment/empty_courses')
  EmptyUsersView = require('views/admin/enrollment/empty_users')
  templateCourses = require('hbs!templates/admin/enrollment/list_courses')
  templateUsers = require('hbs!templates/admin/enrollment/list_users')

  require('jquery_ui')
  require('vendor/plugins/ajax_chosen')

  class EnrollmentUserList extends Marionette.CompositeView

    itemViewContainer: "tbody",
    itemView: ItemView

#    emptyView: EmptyCoursesView

    getTemplate: () =>
      if @collection.searchType() == 'user' then templateUsers else templateCourses

    itemViewOptions: () ->
      {
        role: @collection.role()
        vent: @vent
      }

    ui: {
      studentInput: '[data-behavior="student-input"]'
    }

    appendHtml: (collectionView, itemView, index) ->
      if collectionView.itemViewContainer
        childrenContainer = collectionView.$(collectionView.itemViewContainer)
      else
        childrenContainer = collectionView.$el

      children = childrenContainer.children()
      if children.size() <= index
        childrenContainer.append(itemView.el)
      else
        children.eq(index).before(itemView.el)

    initialize: (options) ->
      @vent = options.vent

      if @collection.searchType() == 'user'
        @emptyView = EmptyUsersView
      else
        @emptyView = EmptyCoursesView

      @collection.fetch()
