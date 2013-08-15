define ['marionette', 'hbs!templates/group/groups_item'], (Marionette, template) ->

  class GroupsItem extends Marionette.ItemView

    tagName: 'li'
    template: template
    attributes: {
      'data-behavior': 'navigate-group'
    }

    triggers: {
      'mouseover a': 'active'
      'mouseout a': 'inactive'
      'click a':   'detail'
    }

    serializeData: () ->
      data = super()
      data.courseId = @options.courseId
      data

    initialize: (options) ->
      @$el.attr('data-group', @model.id)