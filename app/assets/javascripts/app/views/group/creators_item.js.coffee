define ['marionette', 'hbs!templates/course_map/creators_item'], (Marionette, template) ->

  class GroupCreatorsItem extends Marionette.ItemView

    tagName: 'tr'

    template: template

    triggers: {
      'mouseover a': 'active'
      'mouseout a': 'inactive'
      'click a':   'detail'
    }

    attributes: {
      'data-behavior': 'navigate-creator'
    }

    serializeData: () ->
      data = super()
      data.courseId = @options.courseId
      data

    initialize: (options) ->
      @options = options || {}
      @listenTo(@model.collection, 'change:active', (activeCreator) ->
        if activeCreator == @model
          @$el.addClass('selected')
          @$el.removeClass('active')
        else
          @$el.removeClass('selected')
      )
      @$el.attr('data-creator', @model.id)