(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.AbstractModalView = (function(_super) {
    __extends(AbstractModalView, _super);

    function AbstractModalView() {
      _ref = AbstractModalView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    AbstractModalView.prototype.initialize = function(options) {};

    AbstractModalView.prototype.centerModal = function() {
      var xCenter, xOffset, xPosition, yCenter, yOffset, yPosition;

      yOffset = $(document).scrollTop();
      xOffset = $(document).scrollLeft();
      yCenter = $(window).height() / 2;
      xCenter = $(window).width() / 2;
      yPosition = yCenter - (this.$el.find('.js-modal').outerHeight() / 2);
      xPosition = xCenter - (this.$el.find('.js-modal').outerWidth() / 2);
      this.$el.prependTo('body');
      return this.$el.css({
        position: 'absolute',
        zIndex: 300,
        left: (xPosition + xOffset) + 'px',
        top: (yPosition + yOffset) + 'px'
      });
    };

    AbstractModalView.prototype.resizeBackdrop = function() {
      return this.ensureBackdrop().css({
        height: $(document).height()
      });
    };

    AbstractModalView.prototype.ensureBackdrop = function() {
      var backdrop;

      backdrop = $('#js-modal-backdrop');
      if (backdrop.length === 0) {
        backdrop = $('<div id="js-modal-backdrop">').css({
          position: "absolute",
          top: 0,
          left: 0,
          height: $(document).height(),
          width: "100%",
          opacity: 0.5,
          backgroundColor: "#000",
          "z-index": 200
        }).appendTo($('body')).hide();
        $(window).bind('resize', _.bind(this.resizeBackdrop, this));
      }
      return backdrop;
    };

    AbstractModalView.prototype.showBackdrop = function() {
      this.resizeBackdrop();
      return this.ensureBackdrop().fadeIn(250);
    };

    AbstractModalView.prototype.showModal = function() {
      this.showBackdrop();
      return this.centerModal();
    };

    AbstractModalView.prototype.hideModal = function() {
      return this.ensureBackdrop().fadeOut(250);
    };

    return AbstractModalView;

  })(Vocat.Views.AbstractView);

}).call(this);
