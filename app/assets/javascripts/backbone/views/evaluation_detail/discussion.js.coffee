class Vocat.Views.EvaluationDetailDiscussion extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/evaluation_detail/discussion"]

  events:
    'keypress :input': 'savePost'

  initialize: (options) ->
    @submission = options.submission
    @discussions = new Vocat.Collections.DiscussionPost([],{submissionId: @submission.id})
    @discussions.fetch(
      success: =>
        @render()
    )

  savePost: (e) ->
    if e.keyCode == 13
      post = new Vocat.Models.DiscussionPost({
        submission_id: @submission.id
        project_id: @submission.get('project_id')
        creator_id: @submission.get('creator_id')
        body: @$el.find('[data-behavior="post-input"]').val()
        published: true
      })
      post.save({},{
        success: (post) =>
          console.log 'success callback'
          @discussions.add(post)
          @render()
      })

  render: () ->
    context = {
    }

    @$el.html(@template(context))

    postTarget = @$el.find('[data-behavior="post-container"]')
    _.each(@discussions.getParentPosts(), (post) =>
      post = new Vocat.Views.EvaluationDetailPost({discussions: @discussions, model: post})
      console.log post.render().el
      postTarget.append(post.render().el)
    )


    # Return thyself for maximum chaining!
    @
