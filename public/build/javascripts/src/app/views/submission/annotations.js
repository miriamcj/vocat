(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/submission/annotations', 'views/submission/annotations_item', 'views/submission/annotations_item_empty', 'vendor/plugins/smooth_scroll'], function(Marionette, template, ItemView, EmptyView) {
    var AnnotationsView, _ref;

    return AnnotationsView = (function(_super) {
      __extends(AnnotationsView, _super);

      function AnnotationsView() {
        _ref = AnnotationsView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      AnnotationsView.prototype.template = template;

      AnnotationsView.prototype.className = 'annotations';

      AnnotationsView.prototype.triggers = {
        'click [data-behavior="annotations-view-all"]': 'show:all',
        'click [data-behavior="annotations-auto-scroll"]': 'show:active'
      };

      AnnotationsView.prototype.emptyView = EmptyView;

      AnnotationsView.prototype.itemView = ItemView;

      AnnotationsView.prototype.itemViewContainer = '[data-behavior="annotations-container"]';

      AnnotationsView.prototype.ui = {
        count: '[data-behavior="count"]',
        anchor: '[data-behavior="anchor"]',
        scrollParent: '[data-behavior="scroll-parent"]'
      };

      AnnotationsView.prototype.itemViewOptions = function(model, index) {
        return {
          model: model,
          vent: this,
          errorVent: this.vent
        };
      };

      AnnotationsView.prototype.initialize = function(options) {
        var _this = this;

        this.disableScroll = false;
        this.vent = Marionette.getOption(this, 'vent');
        this.attachmentId = Marionette.getOption(this, 'attachmentId');
        this.courseId = Marionette.getOption(this, 'courseId');
        if (this.attachmentId) {
          this.collection.fetch({
            reset: true,
            data: {
              attachment: this.attachmentId
            }
          });
        }
        this.listenTo(this.collection, 'add,remove', function(data) {
          return _this.updateCount();
        });
        return this.listenTo(this.vent, 'player:time', function(data) {
          return _this.trigger('player:time', data);
        });
      };

      AnnotationsView.prototype.onPlayerSeek = function(data) {
        return this.vent.trigger('player:seek', data);
      };

      AnnotationsView.prototype.onItemShown = function(options) {
        var speed;

        if (this.disableScroll === false) {
          if (typeof speed === "undefined" || speed === null) {
            speed = 300;
          }
          return $.smoothScroll({
            direction: 'top',
            speed: speed,
            scrollElement: this.ui.scrollParent,
            scrollTarget: this.ui.anchor
          });
        }
      };

      AnnotationsView.prototype.onAfterItemAdded = function() {
        return this.ui.count.html(this.collection.length);
      };

      AnnotationsView.prototype.onItemRemoved = function() {
        return this.ui.count.html(this.collection.length);
      };

      AnnotationsView.prototype.appendHtml = function(collectionView, itemView, index) {
        var children, childrenContainer;

        if (collectionView.itemViewContainer) {
          childrenContainer = collectionView.$(collectionView.itemViewContainer);
        } else {
          childrenContainer = collectionView.$el;
        }
        children = childrenContainer.children();
        if (children.size() <= index) {
          return childrenContainer.append(itemView.el);
        } else {
          return childrenContainer.children().eq(index).before(itemView.el);
        }
      };

      return AnnotationsView;

    })(Marionette.CompositeView);
  });

}).call(this);
