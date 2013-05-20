class Vocat.Views.EvaluationDetailDiscussion extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/evaluation_detail/discussion"]

  initialize: (options) ->

  render: () ->
    context = {
    }
    @$el.html(@template(context))

    # Return thyself for maximum chaining!
    @
