(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.EvaluationDetail = (function(_super) {
    __extends(EvaluationDetail, _super);

    function EvaluationDetail() {
      _ref = EvaluationDetail.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    EvaluationDetail.prototype.template = HBT["app/templates/evaluation_detail"];

    EvaluationDetail.prototype.defaults = {};

    EvaluationDetail.prototype.initialize = function(options) {
      var _this = this;

      options = _.extend(this.defaults, options);
      if (options.courseId != null) {
        this.courseId = options.courseId;
      }
      if (options.project != null) {
        this.project = options.project;
      } else if (Vocat.Bootstrap.Models.Project != null) {
        this.project = new Vocat.Models.Project(Vocat.Bootstrap.Models.Project, {
          parse: true
        });
      }
      if (options.creator != null) {
        this.creator = options.creator;
      } else if (Vocat.Bootstrap.Models.Creator != null) {
        this.creator = new Vocat.Models.Creator(Vocat.Bootstrap.Models.Creator, {
          parse: true
        });
      }
      if (options.submission != null) {
        this.submission = options.submission;
        this.submissionLoaded();
      } else if (Vocat.Bootstrap.Models.Submission != null) {
        this.submission = new Vocat.Models.Submission(Vocat.Bootstrap.Models.Submission, {
          parse: true
        });
        this.submissionLoaded();
      } else {
        this.submissions = new Vocat.Collections.Submission([], {
          courseId: this.courseId,
          creatorId: this.creator.id,
          projectId: this.project.id
        });
        this.submissions.fetch({
          success: function() {
            _this.submission = _this.submissions.at(0);
            return _this.submissionLoaded();
          }
        });
      }
      return Vocat.Dispatcher.bind('file:transcoded', this.render, this);
    };

    EvaluationDetail.prototype.submissionLoaded = function() {
      var options;

      options = {
        attachmentId: this.submission.get('video_attachment_id')
      };
      this.annotations = new Vocat.Collections.Annotation([], options);
      if (this.submission.get('video_attachment_id')) {
        this.annotations.fetch();
      }
      this.render();
      return window.Vocat.Dispatcher.trigger('courseMap:childViewLoaded', this);
    };

    EvaluationDetail.prototype.render = function() {
      var context;

      context = {
        project: this.project.toJSON(),
        creator: this.creator.toJSON()
      };
      this.$el.html(this.template(context));
      return this.renderChildViews();
    };

    EvaluationDetail.prototype.renderChildViews = function() {
      var annotationsView, annotatorView, childViewOptions, discussionView, playerView, scoreView, uploadView;

      childViewOptions = {
        creator: this.creator,
        project: this.project,
        submission: this.submission
      };
      scoreView = new Vocat.Views.EvaluationDetailScore(childViewOptions);
      annotationsView = new Vocat.Views.EvaluationDetailAnnotations(_.extend(childViewOptions, {
        annotations: this.annotations
      }));
      playerView = new Vocat.Views.EvaluationDetailPlayer(childViewOptions);
      this.$el.find('[data-behavior="score-view"]').first().html(scoreView.render().el);
      this.$el.find('[data-behavior="annotations-view"]').first().html(annotationsView.render().el);
      this.$el.find('[data-behavior="player-view"]').first().html(playerView.render().el);
      if (this.submission.get('current_user_can_discuss') === true) {
        discussionView = new Vocat.Views.EvaluationDetailDiscussion(childViewOptions);
        this.$el.find('[data-behavior="discussion-view"]').first().html(discussionView.el);
      }
      if (this.submission.canBeAnnotated() === true) {
        annotatorView = new Vocat.Views.EvaluationDetailAnnotator(_.extend(childViewOptions, {
          annotations: this.annotations
        }));
        this.$el.find('[data-behavior="annotator-view"]').first().html(annotatorView.render().el);
      }
      if (this.submission.get('current_user_can_attach') === true) {
        uploadView = new Vocat.Views.EvaluationDetailUpload(childViewOptions);
        return this.$el.find('[data-behavior="upload-view"]').first().html(uploadView.render().el);
      }
    };

    return EvaluationDetail;

  })(Vocat.Views.AbstractView);

}).call(this);
