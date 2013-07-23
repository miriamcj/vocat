(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/submission_layout', 'collections/submission_collection', 'collections/annotation_collection', 'collections/evaluation_collection', 'views/submission/player', 'views/submission/annotations', 'views/submission/annotator', 'views/submission/evaluation', 'views/submission/my_evaluation', 'views/submission/upload', 'views/submission/upload/failed', 'views/submission/upload/started', 'views/submission/upload/transcoding', 'views/submission/upload/start', 'views/submission/discussion', 'views/flash/flash_messages', 'models/attachment', 'app/plugins/backbone_poller'], function(Marionette, template, SubmissionCollection, AnnotationCollection, EvaluationCollection, PlayerView, AnnotationsView, AnnotatorView, EvaluationView, MyEvaluationView, UploadView, UploadFailedView, UploadStartedView, UploadTranscodingView, UploadStartView, DiscussionView, FlashMessagesView, Attachment, Poller) {
    var SubmissionLayout, _ref;

    return SubmissionLayout = (function(_super) {
      __extends(SubmissionLayout, _super);

      function SubmissionLayout() {
        _ref = SubmissionLayout.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      SubmissionLayout.prototype.template = template;

      SubmissionLayout.prototype.children = {};

      SubmissionLayout.prototype.regions = {
        flash: '[data-region="flash"]',
        evaluations: '[data-region="evaluations"]',
        myEvaluation: '[data-region="my-evaluation"]',
        discussion: '[data-region="discussion"]',
        upload: '[data-region="upload"]',
        annotator: '[data-region="annotator"]',
        annotations: '[data-region="annotations"]',
        player: '[data-region="player"]'
      };

      SubmissionLayout.prototype.onPlayerStop = function() {};

      SubmissionLayout.prototype.onChangeVideoAttachmentId = function(data) {
        if (this.submission.get('video_attachment_id')) {
          this.children.annotator = new AnnotatorView({
            model: this.submission,
            collection: this.collections.annotation,
            vent: this
          });
          return this.annotator.show(this.children.annotator);
        }
      };

      SubmissionLayout.prototype.onSubmissionFound = function() {
        var _this = this;

        return this.submission.fetch({
          success: function() {
            return _this.triggerMethod('submission:loaded');
          }
        });
      };

      SubmissionLayout.prototype.onSubmissionLoaded = function() {
        this.createEvaluationViews();
        this.createAnnotationView();
        this.createUploadView();
        this.createFlashView();
        this.createPlayerView();
        return this.createDiscussionView();
      };

      SubmissionLayout.prototype.initialize = function(options) {
        var temporaryCollection,
          _this = this;

        this.options = options || {};
        this.collections = options.collections;
        this.collections.annotation = new AnnotationCollection([], {});
        this.courseId = Marionette.getOption(this, 'courseId');
        this.project = Marionette.getOption(this, 'project');
        this.creator = Marionette.getOption(this, 'creator');
        this.submission = this.collections.submission.findWhere({
          project_id: this.project.id,
          creator_id: this.creator.id
        });
        if (!this.submission) {
          temporaryCollection = new SubmissionCollection([], {
            courseId: this.courseId
          });
          return temporaryCollection.fetch({
            data: {
              project: this.project.id,
              creator: this.creator.id
            },
            success: function() {
              _this.submission = temporaryCollection.pop();
              _this.collections.submission.add(_this.submission);
              return _this.triggerMethod('submission:found');
            }
          });
        } else {
          return this.triggerMethod('submission:found');
        }
      };

      SubmissionLayout.prototype.createEvaluationViews = function() {
        var evaluations, models, myEvaluation, myEvaluations;

        evaluations = new EvaluationCollection(this.submission.get('evaluations'), {
          courseId: this.courseId
        });
        if (this.submission.get('current_user_can_evaluate') === true) {
          myEvaluation = evaluations.findWhere({
            current_user_is_owner: true
          });
          if (myEvaluation) {
            models = [myEvaluation];
          } else {
            models = [];
          }
          evaluations.remove(myEvaluation);
          myEvaluations = new EvaluationCollection(models, {
            courseId: this.courseId
          });
          this.myEvaluation.show(new MyEvaluationView({
            collection: myEvaluations,
            model: this.submission,
            project: this.project,
            vent: this,
            courseId: this.courseId
          }));
        }
        return this.evaluations.show(new EvaluationView({
          collection: evaluations,
          model: this.submission,
          project: this.project,
          vent: this,
          courseId: this.courseId
        }));
      };

      SubmissionLayout.prototype.createAnnotationView = function() {
        var attachmentId;

        if (this.submission.get('current_user_can_annotate')) {
          if (this.submission.attachment != null) {
            attachmentId = this.submission.attachment.id;
          } else {
            attachmentId = null;
          }
          return this.annotations.show(new AnnotationsView({
            model: this.submission,
            attachmentId: attachmentId,
            collection: this.collections.annotation,
            vent: this
          }));
        }
      };

      SubmissionLayout.prototype.createUploadView = function() {
        if (this.submission.get('current_user_can_attach')) {
          return this.upload.show(new UploadView({
            model: this.submission,
            collection: this.collections.submission,
            vent: this
          }));
        }
      };

      SubmissionLayout.prototype.createFlashView = function() {
        return this.flash.show(new FlashMessagesView({
          vent: this,
          clearOnAdd: true
        }));
      };

      SubmissionLayout.prototype.createDiscussionView = function() {
        return this.discussion.show(new DiscussionView({
          vent: this,
          submission: this.submission
        }));
      };

      SubmissionLayout.prototype.createPlayerView = function() {
        return this.getPlayerView();
      };

      SubmissionLayout.prototype.startPolling = function() {
        var options, poller,
          _this = this;

        options = {
          delay: 1000,
          delayed: true,
          condition: function(attachment) {
            var out, results;

            results = attachment.get('transcoding_success') === true;
            if (results) {
              _this.triggerMethod('attachment:transcoding:completed', {
                attachment: attachment
              });
              out = false;
            } else {
              out = true;
            }
            return out;
          }
        };
        poller = Poller.get(this.submission.attachment, options);
        return poller.start();
      };

      SubmissionLayout.prototype.getPlayerView = function() {
        var attachment;

        if (this.submission.attachment == null) {
          return this.triggerMethod('attachment:destroyed');
        } else {
          attachment = this.submission.attachment;
          if (attachment) {
            if (attachment.get('transcoding_busy')) {
              this.triggerMethod('attachment:upload:done');
            }
            if (attachment.get('transcoding_error')) {
              this.triggerMethod('attachment:transcoding:failed');
            }
            if (attachment.get('transcoding_success')) {
              return this.triggerMethod('attachment:transcoding:completed');
            }
          }
        }
      };

      SubmissionLayout.prototype.onAttachmentTranscodingCompleted = function(data) {
        if ((data != null) && (data.attachment != null)) {
          this.collections.annotation.fetch({
            data: {
              attachment: data.attachment.id
            }
          });
        }
        this.player.show(new PlayerView({
          model: this.submission.attachment,
          submission: this.submission,
          vent: this
        }));
        return this.annotator.show(new AnnotatorView({
          model: this.submission,
          collection: this.collections.annotation,
          vent: this
        }));
      };

      SubmissionLayout.prototype.onAttachmentUploadDone = function() {
        this.player.show(new UploadTranscodingView({}));
        this.trigger('upload:close');
        return this.startPolling();
      };

      SubmissionLayout.prototype.onAttachmentDestroyed = function() {
        this.collections.annotation.attachmentId = null;
        this.collections.annotation.reset();
        this.player.show(new UploadStartView({
          vent: this
        }));
        return this.annotator.close();
      };

      SubmissionLayout.prototype.onAttachmentUploadFailed = function() {
        return this.player.show(new UploadFailedView({}));
      };

      SubmissionLayout.prototype.onAttachmentUploadStarted = function() {
        return this.player.show(new UploadStartedView({}));
      };

      return SubmissionLayout;

    })(Marionette.Layout);
  });

}).call(this);
