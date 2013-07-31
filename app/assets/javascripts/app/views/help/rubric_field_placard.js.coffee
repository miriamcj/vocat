define [
  'backbone', 'views/help/placard', 'hbs!templates/help/rubric_field_placard'
],(
  Backbone, Placard, template
) ->

  class RubricFieldPlacard extends Placard

    template: template
    className: 'placard wide'
    tagName: 'aside'
    attributes: {
      style: 'display: none'
    }

    initialize: (options) ->
      @orientation = 'nnw'
      @field = options.field
      @key = "rubric:field:#{@field.id}"
      @rubric = options.rubric
      @data = {}
      @data.key = @key
      @initializeEvents()

    serializeData: () ->
      out = {
        fieldName: @field.name
        fieldId: @field.id
        descriptions: []
      }
      _.each(@rubric.ranges, (range) =>
        description = @field.range_descriptions[range.id]
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
