define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/project/detail/project_score_overview')

  class ProjectScoreOverview extends Marionette.ItemView

    template: template

    triggers: {
      'change @ui.viewToggle': {
        event: 'view:toggle'
        preventDefault: false
        stopPropagation: false
      }
    }

    ui: {
      viewToggle: '[data-behavior="view-toggle"]'
    }

    onViewToggle: () ->
      val = @$el.find('[data-behavior="view-toggle"]:checked').val()
      if val == 'project-scores'
        @showProjectScores()
        @percentScoreOpacity('1')
      else
        @showRubricScores()
        if @model.get('rubric_id')
          @percentScoreOpacity('1')
        else
          @percentScoreOpacity('0.4')

    showProjectScores: () ->
      @updateCharts([@model.get('instructor_average'), @model.get('peer_average'), @model.get('self_evaluation_average')])

    showRubricScores: () ->
      if @model.get('rubric_id')
        @updateCharts([@model.get('rubric_instructor_average'), @model.get('rubric_peer_average'), @model.get('rubric_self_eval_average')])
      else
        @updateCharts(['0', '0', '0'])

    updateCharts: (values) ->
      @updateChart('.chartOne', values[0])
      @updateChart('.chartTwo', values[1])
      @updateChart('.chartThree', values[2])

    updateChart: (chartNum, percentage) ->
      per = Math.floor(percentage * 100)
      sliceOne = $(chartNum + ' .slice-one')
      sliceTwo = $(chartNum + ' .slice-two')
      percentScore = $(chartNum + ' .percent-score')

      switch chartNum
        when '.chartOne'
          foreground = '#F6852E'
          background = '#FDE0CB'
        when '.chartTwo'
          foreground = '#866EC4'
          background = '#E1DBF0'
        when '.chartThree'
          foreground = '#3FC068'
          background = '#CFEFD9'

      base = background
      deg = (per/100*360)
      deg1 = 90
      deg2 = deg
      color = foreground
      if per < 50
        color = background
        base = foreground
        deg1 = (per/100*360+90)
        deg2 = 0

      sliceOne.css('transform', "rotate(#{deg1}deg)")
      sliceOne.css('-webkit-transform', "rotate(#{deg1}deg)")
      sliceOne.css('background', color)

      sliceTwo.css('transform', "rotate(#{deg2}deg)")
      sliceTwo.css('-webkit-transform', "rotate(#{deg2}deg)")
      sliceTwo.css('background', color)

      $(chartNum).css('background', base)

      percentScore.text(Math.floor(percentage * 100) + '%')

    percentScoreOpacity: (percent) ->
      $('.percent-score').css('opacity', percent)

    initialize: (options) ->
      @options = options || {}
      @setupListeners()

    setupListeners: () ->
      @listenTo(@model, 'sync', () => @render())

    onRender: () ->
      @showProjectScores()