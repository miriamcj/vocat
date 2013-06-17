class Vocat.Views.PortfolioSubmissionSummary extends Vocat.Views.AbstractView

  ownerTemplate: HBT["app/templates/portfolio/submission_summary_owner"]
  otherTemplate: HBT["app/templates/portfolio/submission_summary_other"]
  scorePartial: HBT["app/templates/partials/score_summary"]

  defaults: {
    showCourse: true
    showCreator: true
  }

  initialize: (options) ->
    options = _.extend(@defaults, options);
    @options = options

  render: () ->
    context = {
      submission: @model.toJSON()
      showCourse: @options.showCourse
      showCreator: @options.showCreator
    }

    if @model.get('current_user_is_owner')
      template = @ownerTemplate
    else
      template = @otherTemplate

    Handlebars.registerPartial('score_summary', @scorePartial);
    @$el.html(template(context))
