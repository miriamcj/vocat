define [
  'backbone', 'views/help/placard', 'hbs!templates/help/rubric_field_placard'
], (Backbone, Placard, template) ->
  class RubricFieldPlacard extends Placard

    template: template
    className: 'placard'
    tagName: 'aside'
    attributes: {
      style: 'display: none'
    }

    onInitialize: () ->
      @rubric = @options.rubric
      @fieldId = @options.fieldId
      @options.showTest = () =>
        if Vocat.glossaryEnabled == true then true else false

      @listenTo(@, 'before:show', (data) => @onBeforeShow(data))
      @listenTo(Vocat.vent, "#{@options.key}:change", (data) =>
        @showScoreDescription(data.score)
      )

    showScoreDescription: (score) ->
      showEl = null
      elements = @$el.find('[data-low]')
      elements.each((index, el) =>
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
        fieldName: @rubric.getFieldNameById(@fieldId)
        fieldId: @fieldId
        descriptions: []
      }
      @rubric.get('ranges').each (range) =>
        out.descriptions.push({
          rangeName: range.get('name')
          rangeLow: range.get('low')
          rangeHigh: range.get('high')
          rangeId: range.id
          rangeDescription: @rubric.getCellDescription(@fieldId, range.id)
        })
      out

    render: () ->
      $('.page-content').prepend(@$el.html(@template(@serializeData())))
