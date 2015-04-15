define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/discussion/discussion')
  DiscusionPostCollection = require('collections/discussion_post_collection')
  DiscussionPostModel = require('models/discussion_post')
  FlashMessagesView = require('views/flash/flash_messages')

  class DiscussionView extends Marionette.CompositeView

    ui:
      bodyInput: '[data-behavior="post-input"]'
      inputToggle: '[data-behavior="input-container"]'
      flashContainer: '[data-container="flash"]'

    triggers:
      'click [data-behavior="post-save"]': 'post:save'
      'click [data-behavior="toggle-reply"]': 'reply:toggle'
      'click [data-behavior="toggle-delete-confirm"]': 'confirm:delete:toggle'
      'click [data-behavior="delete"]': 'post:delete'

    childViewOptions: () ->
      {
      allPosts: @allPosts
      submission: @submission
      }

    onRender: () ->
      @ui.flashContainer.append(@flash.$el)
      @flash.render()

    initializeFlash: () ->
      @flash = new FlashMessagesView({vent: @, clearOnAdd: true})

    onPostSave: () ->
      if @model? then parent_id = @model.id else parent_id = null
      post = new DiscussionPostModel({
        submission_id: @submission.id
        body: @ui.bodyInput.val()
        published: true
        parent_id: parent_id
      })

      # TODO: Fix post input autosizing
      #postInput.val('').trigger('autosize');

      @listenTo(post, 'invalid', (model, errors) =>
        @trigger('error:add', {level: 'error', lifetime: 5000, msg: errors})
      )

      post.save({}, {
        success: (post) =>
          @collection.add(post)
          @allPosts.add(post)
          @resetInput()
        error: (model, error) =>
      })

    initialize: (options) ->
      @vent = options.vent

    onReplyClear: () ->
      @ui.bodyInput.val('')

    resetInput: () ->
      @triggerMethod('reply:clear')
      @triggerMethod('reply:toggle')
