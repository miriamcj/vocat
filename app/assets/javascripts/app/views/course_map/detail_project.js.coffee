define [
  'marionette', 'hbs!templates/course_map/detail_project', 'models/rubric', 'models/project', 'vendor/d3/d3.v3.min', 'vendor/dc/dc', 'vendor/crossfilter/crossfilter'
], (
  Marionette, template, RubricModel, ProjectModel, d3, dc, crossfilter
) ->

  class CourseMapDetailProject extends Marionette.CompositeView

    template: template

    itemViewContainer: '[data-container="submission-summaries"]'

    initializeCharts: () ->
      @render()
      scores = crossfilter(@scores)

      percentageDimension = scores.dimension( (d) =>
        total = 0
        @rubric.get('fields').each((field) =>
          total = total + parseInt(d[field.get('id')])
        )
        console.log total,'total'
        out = Math.round((total / parseInt(@rubric.get('points_possible')) ) * 100)
        console.log out,'out'
        out
      )
      percentageGroup = percentageDimension.group()
      bc = dc.barChart("#bar-chart")
      bc.width(716)
      bc.height(250)

      svg = bc.svg(d3.select("#bar-chart svg"))
      bc.transitionDuration(500)
      bc.margins({top: 20, right: 40, bottom: 20, left: 40})
      bc.dimension(percentageDimension) # set dimension
      bc.group(percentageGroup, 'Evaluations') # set group
      bc.elasticY(true)
      bc.colors(["#5f8688"])
      bc.y(d3.scale.linear())
      bc.x(d3.scale.linear().domain([-3, 103]))
      bc.centerBar(true)
      bc.renderHorizontalGridLines(true)
      bc.legend(dc.legend().x(820).y(10).itemHeight(13).gap(5))
      bc.xAxis().tickFormat( (v) -> "#{v}%" )

      fieldDimensions = []
      fieldGroups = []
      @rubric.get('fields').each((field) =>
        id = field.get('id')
        fieldDimensions[id] = scores.dimension ( (score) ->
          parseInt(score[id])
        )
        fieldGroups[id] = fieldDimensions[id].group()

        dc.pieChart("#pie-chart-#{id}")
          .width(160)
          .legend(dc.legend().x(0).y(0).itemHeight(13).gap(5))
          .height(160)
          .transitionDuration(500)
          .colors(['#344546', '#3d5152', '#455c5e', '#4e686a', '#577375', '#5f7f81', '#688a8d', '#729597', '#7e9da0', '#8aa6a8'])
          .colorDomain(['#232e2f'])
          .radius(80)
          .innerRadius(30)
          .minAngleForLabel(0)
          .dimension(fieldDimensions[id])
          .group(fieldGroups[id])
          #.label( (d) -> d.data.key + ": " + Math.floor(d.data.value / all.value() * 100) + "%" )
          .renderLabel(true)
#          .title( (d) -> return d.data.key + "(" + Math.floor(d.data.value / all.value() * 100) + "%)" )
      )

      dc.renderAll()

    initialize: (options) ->

      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')
      if @model
        # Viewed in coursemap
        @projectId = @model.id
      else
        # Stand alone view
        @projectId = Marionette.getOption(@, 'projectId')
      collections = Marionette.getOption(@, 'collections')

      $.when(@scoresLoaded(), @projectLoaded()).then(() =>
        @initializeCharts()
      )

    serializeData: () ->
      {
        fields: @rubric.get('fields').toJSON() if @rubric?
      }

    projectLoaded: () ->
      deferred = $.Deferred()
      resolve = () =>
        console.log @,'at'
        @rubric = new RubricModel(@model.get('rubric'))
        deferred.resolve()
      unless @model?
        @model = new ProjectModel({id: @projectId})
        @model.fetch({success: resolve})
      else
        resolve()
      deferred

    scoresLoaded: () ->
      deferred = $.Deferred()
      $.ajax("/api/v1/courses/#{@courseId}/projects/#{@projectId}/scores",{
        dataType: 'json'
        success: (data, textStatus, jqXHR) =>
          console.log data,'data'
          @scores = data
          deferred.resolve()
      })
      deferred
