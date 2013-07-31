define [
  'backbone', 'views/help/placard', 'hbs!templates/help/rubric_field_placard'
],(
  Backbone, Placard, template
) ->

  class RubricFieldPlacard extends Placard

    template: template
    className: 'placard'
    tagName: 'aside'
    attributes: {
      style: 'display: none'
    }

    onInitialize: () ->
      @options.showTest = () =>
        if Vocat.glossaryEnabled == true then true else false

      @listenTo(@, 'before:show', (data) => @onBeforeShow(data))
      @listenTo(Vocat.vent, "#{@options.key}:change", (data) =>
        @showScoreDescription(data.score)
      )

    showScoreDescription: (score) ->
      showEl = null
      elements = @$el.find('[data-low]')
      elements.each( (index, el) =>
        $el = $(el)
        data = $el.data()
        if parseInt(data.low) <= score && parseInt(data.high) >= score
          showEl = $el
      )
      unless showEl? then showEl = elements.first()
      elements.hide()
      showEl.show()

    onBeforeShow: (data) ->
      if @visible == false
        score = data.data.score
        @showScoreDescription(score)

    serializeData: () ->
      out = {
        fieldName: @options.field.name
        fieldId: @options.field.id
        descriptions: []
      }
      _.each(@options.rubric.ranges, (range) =>
        description = @options.field.range_descriptions[range.id]
        out.descriptions.push({
          rangeName: range.name
          rangeLow: range.low
          rangeHigh: range.high
          rangeId: range.id
          rangeDescription: description
        })
      )
      out

    render: () ->
      $('.page-content').prepend(@$el.html(@template(@serializeData())))
