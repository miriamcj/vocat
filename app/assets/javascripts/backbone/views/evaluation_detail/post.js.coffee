class Vocat.Views.EvaluationDetailPost extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/evaluation_detail/post"]
  tagName: 'li'
  className: 'discussion-list--item'

  initialize: (options) ->
    @discussions = options.discussions

  render: () ->
    context = {
      post: @model.toJSON()
    }
    @$el.html(@template(context))

    # Return thyself for maximum chaining!
    @
