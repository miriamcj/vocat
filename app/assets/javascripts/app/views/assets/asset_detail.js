/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let AssetShowLayout;
const Marionette = require('marionette');
const template = require('hbs!templates/assets/asset_detail');
const VideoPlayerView = require('views/assets/player/video_player');
const ImagePlayerView = require('views/assets/player/image_player');
const ProcessingWarningView = require('views/assets/player/processing_warning');
const AnnotatorView = require('views/assets/annotator/annotator');
const AnnotatorCanvasView = require('views/assets/annotator/annotator_canvas');
const MockCanvasView = require('views/assets/annotator/mock_canvas');
const AnnotationsView = require('views/assets/annotations/annotations');

export default AssetShowLayout = (function() {
  AssetShowLayout = class AssetShowLayout extends Marionette.LayoutView {
    static initClass() {

      this.prototype.template = template;

      this.prototype.ui = {
        detailClose: '[data-behavior="detail-close"]',
        playerColumn: '[data-behavior="player-column"]',
        annotationsColumn: '[data-behavior="annotations-column"]',
        message: '[data-behavior="message"]'
      };

      this.prototype.triggers = {
        'click @ui.detailClose': 'detail:close'
      };

      this.prototype.regions = {
        player: '[data-region="player"]',
        annotations: '[data-region="annotations"]',
        annotationsStage: '[data-region="annotations-stage"]',
        annotator: '[data-region="annotator"]',
        annotatorCanvas: '[data-region="annotator-canvas"]'
      };
    }

    handleMessageShow(data) {
      const { msg } = data;
      this.ui.message.html(msg);
      return this.ui.message.addClass('open');
    }

    handleMessageHide(data) {
      this.ui.message.html('');
      return this.ui.message.removeClass('open');
    }

    selectPlayerView() {
      let playerView;
      const viewConstructorArguments = {model: this.model, vent: this.vent};
      if (this.model.get('attachment_state') === 'processed') {
        const family = this.model.get('family');
        switch (family) {
          case 'video': playerView = new VideoPlayerView(viewConstructorArguments); break;
          case 'image': playerView = new ImagePlayerView(viewConstructorArguments); break;
          case 'audio': playerView = new VideoPlayerView(viewConstructorArguments); break;
        }
      } else {
        playerView = new ProcessingWarningView(viewConstructorArguments);
      }
      return playerView;
    }

    pickAnnotationsView(asset) {
      let annotationsView;
      return annotationsView = new AnnotationsView({model: asset, vent: this.vent});
    }

    onShow() {
      const annotationsView = this.pickAnnotationsView(this.model);
      const annotatorView = this.pickAnnotatorView(this.model);
      const canvasView = this.pickCanvasView(this.model);
      const playerView = this.selectPlayerView();
      this.player.show(playerView);
      if (annotatorView) { this.annotator.show(annotatorView); }
      if (canvasView) { this.annotatorCanvas.show(canvasView); }
      if (annotationsView) { return this.annotations.show(annotationsView); }
    }

    pickCanvasView(asset) {
      const canDisplayCanvas = asset.allowsVisibleAnnotation();
      if (canDisplayCanvas === true) {
        return new AnnotatorCanvasView({model: this.model, vent: this.vent});
      } else {
        return new MockCanvasView({model: this.model, vent: this.vent});
      }
    }

    pickAnnotatorView(asset) {
      // Stub method - currently all assets can be annotated, but this may change in the future.
      return new AnnotatorView({model: this.model, vent: this.vent});
    }

    serializeData() {
      const data = super.serializeData();
      data.hasDuration = this.model.hasDuration();
      return data;
    }

    onDetailClose() {
      let url;
      const context = this.model.get('creator_type').toLowerCase() + 's';
      if (this.viewContext === 'coursemap') {
        url = `courses/${this.courseId}/${context}/evaluations/creator/${this.model.get('creator_id')}/project/${this.model.get('project_id')}`;
      } else {
        url = `courses/${this.courseId}/${context}/creator/${this.model.get('creator_id')}/project/${this.model.get('project_id')}`;
      }
      return Vocat.router.navigate(url, true);
    }

    initialize(options) {
      this.viewContext = options.context;
      this.courseId = window.VocatCourseId;
      this.vent = new Backbone.Wreqr.EventAggregator();
      this.listenTo(this.vent, 'request:message:show', this.handleMessageShow, this);
      return this.listenTo(this.vent, 'request:message:hide', this.handleMessageHide, this);
    }
  };
  AssetShowLayout.initClass();
  return AssetShowLayout;
})();
