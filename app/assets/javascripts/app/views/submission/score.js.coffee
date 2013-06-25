define [
  'marionette', 'hbs!templates/submission/score'
], (
  Marionette, template
) ->
  class EvaluationDetailScore extends Marionette.ItemView

    template: template

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')

#    scorePartial: HBT["app/templates/partials/score_summary"]
#
#    events: {
#      'click .js-toggle-score-detail': "toggleDetail"
#      'click .js-toggle-score-help': "toggleHelp"
#    }
#
#    initialize: (options) ->
#      super(options)
#
#      @submission = options.submission
#
#
#    fadeDetail: () ->
#      # Rendering after fade is complete to update button state. Probably
#      # a more elegant solution
#      if @state.get('detailVisible') is false
#        $('.score-list-expanded').fadeOut(400, => @render())
#      else
#        $('.score-list-expanded').fadeIn( 400, => @render())
#
#    toggleHelp: (event) ->
#      event.preventDefault()
#      newState = if @state.get('helpVisible') is true then false else true
#      @state.set('helpVisible', newState )
#
#    toggleDetail: (event) ->
#      event.preventDefault()
#      newState = if @state.get('detailVisible') is true then false else true
#      @state.set('detailVisible', newState )
#
#    render: () ->
#      context = {
#        state: @state.toJSON()
#        submission: if @submission? then @submission.toJSON()
#      }
#      Handlebars.registerPartial('score_summary', @scorePartial);
#      @$el.html(@template(context))
#
#      # Return thyself for maximum chaining!
#      @


