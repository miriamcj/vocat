/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/discussion/discussion.hbs';
import DiscusionPostCollection from 'collections/discussion_post_collection';
import DiscussionPostModel from 'models/discussion_post';
import FlashMessagesView from 'views/flash/flash_messages';

export default class DiscussionView extends Marionette.CompositeView.extend({
  ui: {
    bodyInput: '[data-behavior="post-input"]',
    inputToggle: '[data-behavior="input-container"]',
    flashContainer: '[data-container="flash"]'
  },

  triggers: {
    'click [data-behavior="post-save"]': 'post:save',
    'click [data-behavior="toggle-reply"]': 'reply:toggle',
    'click [data-behavior="toggle-delete-confirm"]': 'confirm:delete:toggle',
    'click [data-behavior="delete"]': 'post:delete'
  }
}) {
  childViewOptions() {
    return {
    allPosts: this.allPosts,
    submission: this.submission
    };
  }

  onRender() {
    this.ui.flashContainer.append(this.flash.$el);
    return this.flash.render();
  }

  initializeFlash() {
    return this.flash = new FlashMessagesView({vent: this, clearOnAdd: true});
  }

  onPostSave() {
    let parent_id;
    if (this.model != null) { parent_id = this.model.id; } else { parent_id = null; }
    const post = new DiscussionPostModel({
      submission_id: this.submission.id,
      body: this.ui.bodyInput.val(),
      published: true,
      parent_id
    });

    // TODO: Fix post input autosizing
    //postInput.val('').trigger('autosize');

    this.listenTo(post, 'invalid', (model, errors) => {
      return this.trigger('error:add', {level: 'error', lifetime: 5000, msg: errors});
    });

    return post.save({}, {
      success: post => {
        this.collection.add(post);
        this.allPosts.add(post);
        return this.resetInput();
      },
      error: (model, error) => {}
    });
  }

  initialize(options) {
    return this.vent = options.vent;
  }

  onReplyClear() {
    return this.ui.bodyInput.val('');
  }

  resetInput() {
    this.triggerMethod('reply:clear');
    return this.triggerMethod('reply:toggle');
  }
};
