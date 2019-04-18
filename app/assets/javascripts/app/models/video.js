/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

export default class VideoModel extends Backbone.Model {
  constructor() {

    this.paramRoot = 'video';

    this.urlRoot = "/api/v1/videos";
  }

  getSourceDetails() {
    switch (this.get('source')) {
      case 'youtube':
        return {
        mime: 'video/youtube',
        key: 'youtube'
        };
      case 'vimeo':
        return {
        mime: 'video/vimeo',
        key: 'vimeo'
        };
      case 'attachment':
        return {
        mime: 'video/mp4',
        key: 'html5'
        };
    }
  }
};
