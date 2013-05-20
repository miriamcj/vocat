class Vocat.Views.EvaluationDetailScore extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/evaluation_detail/score"]
  scorePartial: HBT["backbone/templates/partials/score_summary"]

  events: {
    'click .js-toggle-score-detail': "toggleDetail"
    'click .js-toggle-score-help': "toggleHelp"
  }

  initialize: (options) ->
    super(options)

    @submission = options.submission

    # Set the default state for the view
    @state = new Vocat.Models.ViewState({
      helpVisible: false
      detailVisible: false
    })

    # Bind render to changes in view state
    @state.bind('change:helpVisible', @render, @)
    @state.on('change:detailVisible', @fadeDetail, @)

  fadeDetail: () ->
    # Rendering after fade is complete to update button state. Probably
    # a more elegant solution
    if @state.get('detailVisible') is false
      $('.score-list-expanded').fadeOut(400, => @render())
    else
      $('.score-list-expanded').fadeIn( 400, => @render())

  toggleHelp: (event) ->
    event.preventDefault()
    newState = if @state.get('helpVisible') is true then false else true
    @state.set('helpVisible', newState )

  toggleDetail: (event) ->
    event.preventDefault()
    newState = if @state.get('detailVisible') is true then false else true
    @state.set('detailVisible', newState )

  render: () ->
    context = {
      state: @state.toJSON()
      submission: @submission.toJSON()
    }
    Handlebars.registerPartial('score_summary', @scorePartial);
    @$el.html(@template(context))

    # Return thyself for maximum chaining!
    @


