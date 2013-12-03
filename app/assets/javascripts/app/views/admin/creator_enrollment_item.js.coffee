define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment_item_view')

  class CreatorEnrollmentItem extends Marionette.ItemView

    template: template
    tagName: 'tr'
    itemView: CreatorEnrollmentItem

    triggers: () ->
      'click [data-behavior="destroy"]': 'clickDestroy'

    initialize: () ->

    onClickDestroy: () ->
      @model.destroy()

    onRender: () ->
      console.log 'item rendered'