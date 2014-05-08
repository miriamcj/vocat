define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/project/detail/crossfiltered')

  class ProjectDetailCrossfilteredView extends Marionette.ItemView

    template: template

    currentFilters: {}
    barChart: null
    pieCharts: []

    triggers: {
      'click [data-trigger="filters-clear"]': 'filters:clear'
    }

    ui: {
      filtersClear:   '[data-trigger="filters-clear"]'
      barFilterLabel: '[data-behavior="bar-filter-label"]'
      pieFilterLabel: '[data-behavior="pie-filter-label"]'
      barFilterLabelWrap: '[data-behavior="bar-filter-label-wrap"]'
      pieFilterLabelWrap: '[data-behavior="pie-filter-label-wrap"]'
    }


    initialize: (options) ->
      @scores = Marionette.getOption(@, 'scores')
      @rubric = Marionette.getOption(@, 'rubric')

    onShow: () ->
      @initializeCharts()

    onFiltersClear: () ->
      dc.filterAll('projectCharts')
      dc.redrawAll('projectCharts')

    initializeCharts: () ->
      @render()

      # Pass scores through crossfilter
      scores = crossfilter(@scores)

      # Make the bar chart
      totalDimension = scores.dimension( (d) =>
        total = 0
        @rubric.get('fields').each((field) =>
          total = total + parseInt(d[field.get('id')])
        )
        Math.round((total / parseInt(@rubric.get('points_possible')) ) * 100)
      )
      totalGroup = totalDimension.group()
      @barChart = @createBarChart(totalDimension, totalGroup)

      # Make the pie charts
      @pieCharts = []
      @rubric.get('fields').each((field) =>
        dimension = scores.dimension (score) -> parseInt(score[field.get('id')])
        group = dimension.group()
        pieChart = @createPieChart(field.get('id'), dimension, group)
        @pieCharts.push pieChart
      )

      # Render the charts
      dc.renderAll('projectCharts')
      @updateFilters()

    updateFilters: () ->
      filterStringParts = []

      bcFilter = _.clone(@barChart.filter())
      if bcFilter? && bcFilter.length == 2
        low = Math.round(bcFilter[0])
        high = Math.round(bcFilter[1])
        bcFilter = "a <strong>total score between #{low}% and #{high}%</strong>"

      # The following logic is mostly about trying to get punctuation correct. We're basically
      # compiling nested lists here, which means there are lots of cases around when we do or
      # don't use a comma or a semicolon.
      _.each @pieCharts, (pc) =>
        filters = _.clone(pc.filters())
        filters.sort()
        count = filters.length
        if count > 0
          last = filters.pop()
          if count > 2
            s = "#{filters.join(', ')}, or #{last}"
          else if count == 2
            s = "#{filters.join(', ')} or #{last}"
          else
            s = last
          filterStringParts.push "<strong>#{s} on #{@rubric.getFieldNameById(pc.vocat_id).toLowerCase()}</strong>"

      strings = {
        bar: "This graph is currently displaying the <strong>overall score distribution</strong>"
        pie: "These pie charts are currently displaying the <strong>criteria score distribution</strong>"
      }

      # You gots to fade it out, before you fadez it in.
      _.each ['bar', 'pie'], (key) =>

        parts = _.clone(filterStringParts)

        if key == 'pie' && bcFilter?
          parts.push(bcFilter)

        if _.some(parts, (string) -> string.indexOf(',') != -1) then sep = '; ' else sep =', '

        partsCount = parts.length
        if partsCount > 2
          last = parts.pop()
          filterString = "for submissions that received a score of #{parts.join(sep)}#{sep} and #{last}."
        else if partsCount > 1
          filterString = "for submissions that received a score of #{parts.join(' and ')}."
        else if partsCount == 1
          filterString = "for submissions that received a score of #{parts[0]}."
        else
          filterString = "for all project submissions."
        finalString = "#{strings[key]} #{filterString}"

        if @ui["#{key}FilterLabel"] && finalString  != @ui["#{key}FilterLabel"].html()
          @ui["#{key}FilterLabelWrap"].fadeOut 200, () =>
            if partsCount > 0
              @ui["#{key}FilterLabelWrap"].find('[data-trigger="filters-clear"]').show()
            else
              @ui["#{key}FilterLabelWrap"].find('[data-trigger="filters-clear"]').hide()
            @ui["#{key}FilterLabel"].html(finalString )
            @ui["#{key}FilterLabelWrap"].fadeIn(200)


    createBarChart: (dimension, group) ->
      bc = dc.barChart("#bar-chart",'projectCharts')
      bc.width(716)
      bc.height(255)
      bc.transitionDuration(500)
      bc.margins({top: 10, right: 40, bottom: 20, left: 20})
      bc.dimension(dimension) # set dimension
      bc.group(group, 'Evaluations') # set group
      bc.elasticY(true)
      bc.colors(["#5f8688"])
      bc.y(d3.scale.linear())
      bc.x(d3.scale.linear().domain([0, 100]))
      bc.centerBar(true)
      bc.renderHorizontalGridLines(true)
      bc.renderVerticalGridLines(true)
      bc.yAxis().ticks(6).tickFormat( (v) -> if Math.floor(v) != v then return else return v)
      bc.xAxis().tickFormat( (v) -> "#{v}%" )

      bc.vocat_id = 'total'
      bc.on('filtered', (chart, filter) =>
        dc.events.trigger( () =>
          @updateFilters()
        )
      )

      bc.renderlet (chart) ->
        svg = chart.select('svg')
        if $(svg[0]).find('.background-custom').length == 0
          chart.select('svg').insert('rect','g').attr('width', 656).attr('height', 225).attr('transform','translate(20,10)').attr('class', 'background-custom')
      bc

    createPieChart: (id, dimension, group) ->
      pc = dc.pieChart("#pie-chart-#{id}", 'projectCharts')
      pc.width(157)
      pc.legend(dc.legend().x(0).y(0).itemHeight(13).gap(5))
      pc.height(157)
      pc.transitionDuration(500)
      pc.colorDomain(['#232e2f'])
      pc.radius(75)
      pc.innerRadius(0)
      pc.minAngleForLabel(0)
      pc.dimension(dimension)
      pc.group(group)
      pc.renderLabel(true)
      pc.vocat_id = id

      pc.on('filtered', (chart, filter) =>
        @updateFilters(chart, filter)
      )
      pc

    serializeData: () ->
      {
        fields: @rubric.get('fields').toJSON() if @rubric?
      }

