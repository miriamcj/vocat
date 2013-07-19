define [
  'marionette', 'hbs!templates/submission/discussion', 'collections/discussion_post_collection', 'models/discussion_post'
], (
  Marionette, template, DiscussionPostCollection, DiscussionPostModel
) ->

  class DiscussionView extends Marionette.CompositeView

    ui:
      bodyInput: '[data-behavior="post-input"]'
      inputToggle: '[data-behavior="input-container"]'

    itemViewOptions: () ->
      {
      allPosts: @allPosts
      submission: @submission
      }

    onPostSave: () ->
      if @model? then parent_id = @model.id else parent_id = null
      post = new DiscussionPostModel({
        submission_id: @submission.id
        body: @ui.bodyInput.val()
        published: true
        parent_id: parent_id
      })
      # postInput.val('').trigger('autosize');
      # TODO: Users should not be able to save empty posts.
      post.save({},{
        success: (post) =>
          @collection.add(post)
          @allPosts.add(post)
          @resetInput()
      })

    onReplyClear: () ->
      @ui.bodyInput.val('')

    resetInput: () ->
      @triggerMethod('reply:clear')
      @triggerMethod('reply:toggle')
