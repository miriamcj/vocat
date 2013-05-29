# VOCAT 3: The Phoenix Rises from the Ashes

# (c) 2013 Baruch College, CUNY
# Created by Zach Davis, Cast Iron Coding
# http://castironcoding.com
class Vocat.Views.EvaluationDetail extends Vocat.Views.AbstractView

  # Initial Setup
  # -------------

  # Set the view's template.
  template: HBT["backbone/templates/evaluation_detail"]

  # Assign any default values to the view.
  defaults: {
  }

  initialize: (options)  ->

    # Overlay options on top of this view's defaults.
    options = _.extend(@defaults, options);

    # Assign the current course ID to the view so that it can be incorp@submission.ide course ID
    # to be { data: $.param({ attachment: }) }passed to this object throught the options. In some cases, the data for this view is bootstrapped onto the
    # page, in which case the course ID is generally not needed.
    if options.courseId?
      @courseId = options.courseId

    # Set the evaluation detail's project from the options (if we're in the course map), or from the bootstrapped data
    # (if we're on the creator evaluation detail view).
    if options.project?
      @project = options.project
    else if Vocat.Bootstrap.Models.Project?
      @project = new Vocat.Models.Project(Vocat.Bootstrap.Models.Project, {parse: true})

    # Like the project, the creator model for this view can be passed in via options or bootstrapped into the page.
    if options.creator?
      @creator = options.creator
    else if Vocat.Bootstrap.Models.Creator?
      @creator = new Vocat.Models.Creator(Vocat.Bootstrap.Models.Creator, {parse: true})

    # Similarly, the detail's submission can be set from options or bootstrapped data. Unlike projects and creators,
    # the submission will be fetched asynchronously if it's not present during view initialization. The submission is
    # the principal model for this view, so the rendering is defered until the submission has been loaded.
    if options.submission?
      @submission = options.submission
      @submissionLoaded()
    else if Vocat.Bootstrap.Models.Submission?
      @submission = new Vocat.Models.Submission(Vocat.Bootstrap.Models.Submission, {parse: true})
      @submissionLoaded()
    else
      # A single submission is typically fetched by project and creator ID, not by submission ID, because a submission
      # is created just-in-time on the backend if it does not already exist.
      @submissions = new Vocat.Collections.Submission([], {
        courseId: @courseId
        creatorId: @creator.id
        projectId: @project.id
      })
      @submissions.fetch({
        success: =>
          @submission = @submissions.at(0)
          @submissionLoaded()
      })

    # The evalutation detail view needs to redraw itself to load the video once it sees that transcoding has been
    # completed.
    Vocat.Dispatcher.bind('file:transcoded', @render, @)

  # Once the submission has been loaded, we can check if the submission has an attachment and, if it does, we can fetch
  # annotations for that attachment. We can also render the view at this point.
  submissionLoaded: () ->
    options = {attachmentId: @submission.get('video_attachment_id')}
    @annotations = new Vocat.Collections.Annotation([], options)
    if @submission.get('video_attachment_id')
      @annotations.fetch();
    @render()
    window.Vocat.Dispatcher.trigger('courseMap:childViewLoaded', @)

  render: () ->
    # The evaluation detail view is by and large a wrapper around a handful of child views. Therefore, it doesn't need
    # very much information.
    context = {
      project: @project.toJSON()
      creator: @creator.toJSON()
    }

    # Render this view onto the page.
    @$el.html(@template(context))

    # Then `renderChildViews` into the rendered evaulation detail HTML.
    @renderChildViews()


  renderChildViews: () ->

    # This hash forms the basis of the options passed to the child views.
    childViewOptions = {
      creator: @creator
      project: @project
      submission: @submission
    }


    # The score view, annotations view, and the player view should always be visible.
    scoreView       = new Vocat.Views.EvaluationDetailScore(childViewOptions)
    annotationsView = new Vocat.Views.EvaluationDetailAnnotations(_.extend(childViewOptions, {annotations: @annotations}))
    playerView      = new Vocat.Views.EvaluationDetailPlayer(childViewOptions)

    # Our method for rendering views is to render the view's element into the parent container.
    # See http://stackoverflow.com/questions/11274806/backbone-render-return-this
    @$el.find('[data-behavior="score-view"]').first().html(scoreView.render().el)
    @$el.find('[data-behavior="annotations-view"]').first().html(annotationsView.render().el)
    @$el.find('[data-behavior="player-view"]').first().html(playerView.render().el)

    # The rest of the views are conditional, depending on user's abilities.
    if @submission.get('current_user_can_discuss') == true
      discussionView = new Vocat.Views.EvaluationDetailDiscussion(childViewOptions)
      # We don't render the discussion view, because it renders itself after fetching posts.
      @$el.find('[data-behavior="discussion-view"]').first().html(discussionView.el)

    if @submission.canBeAnnotated() == true
      annotatorView = new Vocat.Views.EvaluationDetailAnnotator(_.extend(childViewOptions, {annotations: @annotations}))
      @$el.find('[data-behavior="annotator-view"]').first().html(annotatorView.render().el)

    if @submission.get('current_user_can_attach') == true
      uploadView = new Vocat.Views.EvaluationDetailUpload(childViewOptions)
      @$el.find('[data-behavior="upload-view"]').first().html(uploadView.render().el)
