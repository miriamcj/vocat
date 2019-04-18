/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

let VideoModel;

export default VideoModel = (function() {
  VideoModel = class VideoModel extends Backbone.Model {
    static initClass() {

      this.prototype.paramRoot = 'video';

      this.prototype.urlRoot = "/api/v1/videos";
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
  VideoModel.initClass();
  return VideoModel;
})();
