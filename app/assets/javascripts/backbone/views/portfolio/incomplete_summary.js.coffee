class Vocat.Views.PortfolioIncompleteSummary extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/portfolio/incomplete_summary_owner"]
  scorePartial: HBT["backbone/templates/partials/score_summary"]

  initialize: (options) ->
    super (options)

  render: () ->
    context = {
      project: @model.toJSON()
    }
    Handlebars.registerPartial('score_summary', @scorePartial);
    @$el.html(@template(context))
