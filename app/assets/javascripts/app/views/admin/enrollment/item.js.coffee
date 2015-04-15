define (require) ->
  Marionette = require('marionette')
  userItemTemplate = require('hbs!templates/admin/enrollment/list_users_item')
  courseItemTemplate = require('hbs!templates/admin/enrollment/list_courses_item')

  class CreatorEnrollmentItem extends Marionette.ItemView

    tagName: 'tr'

    getTemplate: () =>
      if @model.collection.searchType() == 'user' then return userItemTemplate else return courseItemTemplate

    triggers: () ->
      'click [data-behavior="destroy"]': 'clickDestroy'

    initialize: (options) ->
      @vent = options.vent

    serializeData: () ->
      out = super()
      out.isAdmin = (window.VocatUserRole == 'administrator')
      out

    onClickDestroy: () ->
      @model.destroy({
        wait: true
        success: (model) =>
          Vocat.vent.trigger('error:add', {
            level: 'notice',
            lifetime: 5000,
            msg: "#{model.get('user_name')} has been removed from section ##{model.get('section')}."
          })
        error: (model, xhr) =>
          Vocat.vent.trigger('error:add', {level: 'error', lifetime: 5000, msg: xhr.responseJSON.errors})
      })

    onRender: () ->
