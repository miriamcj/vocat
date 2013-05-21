class Vocat.Views.EvaluationDetailAnnotations extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/evaluation_detail/annotations"]

  className: 'annotations'

  events:
    'click [data-behavior="annotations-view-all"]': 'viewAllAnnotations'
    'click [data-behavior="annotations-auto-scroll"]': 'enableAutoScroll'

  initialize: (options) ->
    @project = options.project
    @submission = options.submission
    @creator = options.creator
    @annotations = options.annotations
    @disableScroll = false
    @annotations.bind 'reset', @render, @
    @annotations.bind 'add', @insertView, @
    Vocat.Dispatcher.bind 'playerTimeUpdate', @showAnnotations, @

  doScroll: (speed, target, offset) ->
    if @disableScroll == false
      if !speed? then speed = 300
      if !target? then taret = @$el.find('.annotation--scroll-anchor')
      $.smoothScroll({
        direction: 'top'
        speed: speed
        scrollElement: @$el.find('[data-behavior="scroll-parent"]')
        scrollTarget: target
        offset: offset
      })

  enableAutoScroll: (e) ->
    e.preventDefault()
    @$el.find('[data-behavior="annotations-view-all"]').show()
    @$el.find('[data-behavior="annotations-auto-scroll"]').hide()
    @disableScroll = false
    @annotations.each (annotation) ->
      annotation.unlock()
    @showAnnotations({seconds: @currentTime})

  viewAllAnnotations: (e) ->
    e.preventDefault()
    @$el.find('[data-behavior="annotations-view-all"]').hide()
    @$el.find('[data-behavior="annotations-auto-scroll"]').show()
    @disableScroll = true
    @annotations.each (annotation) ->
      annotation.lockVisible()

  showAnnotations: (args) ->
    seconds = Math.floor(args.seconds)
    @currentTime = seconds
    @annotations.each (annotation) ->
      if annotation.get('seconds_timecode') <= seconds
        annotation.show()
      else
        annotation.hide()

    visibleAnnotations = @annotations.filter (annotation) ->
      annotation.visible == true

    visibleValues = _.map visibleAnnotations, (annotation) ->
      annotation.get('seconds_timecode')

    pastVisibleValues = _.reject visibleValues, (value) ->
      value > seconds

    if pastVisibleValues.length > 0
      maxVisible = _.max pastVisibleValues
    else
      maxVisible = 0

    target = @$el.find('[data-seconds="' + maxVisible + '"]')
    @doScroll(300, target)

  insertView: (annotation) ->
    insertAt = annotation.get('seconds_timecode')
    before = @annotations.find (annotation) ->
      annotation.get('seconds_timecode') > insertAt

    childView = new Vocat.Views.EvaluationDetailAnnotation({model: annotation})
    @childViews[annotation.id] = childView

    if before?
      beforeEl = @childViews[before.id].el
      $(beforeEl).before(childView.render().el)
    else
      @$el.find('[data-behavior="annotations-container"]').append(childView.render().el)

    @updateCount()

  updateCount: () ->
    @$el.find('[data-behavior="count"]').html(@annotations.length)

  render: () ->
    context = {
      currentTime: @currentTime
      count: @annotations.length
      disableScroll: @disableScroll
      submission: @submission.toJSON()
    }
    @$el.html(@template(context))
    annotationsContainer = @$el.find('[data-behavior="annotations-container"]')
    @childViews = new Array
    @annotations.each (annotation) =>
      childView = new Vocat.Views.EvaluationDetailAnnotation({model: annotation})
      @childViews[annotation.id] = childView
      annotationsContainer.append(childView.render().el)

    # Return thyself for maximum chaining!
    @
