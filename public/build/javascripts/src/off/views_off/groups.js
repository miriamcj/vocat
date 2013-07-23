(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Vocat.Views.Groups = (function(_super) {
    __extends(Groups, _super);

    function Groups() {
      _ref = Groups.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Groups.prototype.template = HBT["app/templates/groups"];

    Groups.prototype.events = {
      'click [data-behavior="create-group"]': 'createGroup',
      'click [data-behavior="draggable-user"]': 'toggleSelect'
    };

    Groups.prototype.initialize = function(options) {
      if (Vocat.Bootstrap.Collections.Group != null) {
        this.groups = new Vocat.Collections.Group(Vocat.Bootstrap.Collections.Group);
      }
      if (Vocat.Bootstrap.Collections.Creator != null) {
        this.creators = new Vocat.Collections.Creator(Vocat.Bootstrap.Collections.Creator);
      }
      return this.render();
    };

    Groups.prototype.createGroup = function() {
      var group, name;

      name = this.$el.find('[data-behavior="group-name"]').val();
      group = new Vocat.Models.Group({
        name: name
      });
      group.save();
      if (group.validationError) {
        return Vocat.Dispatcher.trigger('flash', {
          scope: 'groups',
          level: 'error',
          message: group.validationError
        });
      }
    };

    Groups.prototype.select = function(element) {
      var $target;

      $target = $(element);
      $target.addClass('selected');
      return $target.attr('data-selected', 1);
    };

    Groups.prototype.unselect = function(element) {
      var $target;

      $target = $(element);
      $target.removeClass('selected');
      return $target.attr('data-selected', 0);
    };

    Groups.prototype.toggleSelect = function(e) {
      var $target, target;

      target = $(e.currentTarget).find('.groups--owner');
      $target = $(target);
      $target.toggleClass('selected');
      if ($target.hasClass('selected')) {
        return $target.attr('data-selected', 1);
      } else {
        return $target.attr('data-selected', 0);
      }
    };

    Groups.prototype.animateMove = function(el, ui) {
      var increment, targetDegrees, targetOffset;

      el = $(el);
      targetOffset = ui.helper.offset();
      console.log(targetOffset);
      console.log(targetOffset);
      ui.helper.find('.groups--owner').css({
        zIndex: 20,
        position: 'absolute',
        border: '2px solid green'
      });
      el.appendTo(ui.helper);
      el.css({
        position: 'absolute',
        top: 0,
        left: 0,
        zIndex: 10
      });
      targetDegrees = this.getRandomInt(0, 30);
      increment = Math.ceil(targetDegrees / 100);
      console.log(increment, targetDegrees);
      return el.animate({
        borderSpacing: -90
      }, {
        step: function(now, fx) {
          var $target, move;

          move = now * increment;
          console.log(move, increment);
          $target = $(this);
          $target.css('-webkit-transform', 'rotate(' + move + 'deg)');
          $target.css('-moz-transform', 'rotate(' + move + 'deg)');
          $target.css('-ms-transform', 'rotate(' + move + 'deg)');
          $target.css('-o-transform', 'rotate(' + move + 'deg)');
          return $target.css('transform', 'rotate(' + move + 'deg)');
        },
        duration: '100'
      }, 'linear');
    };

    Groups.prototype.getRandomInt = function(min, max) {
      return Math.floor(Math.random() * (max - min + 1)) + min;
    };

    Groups.prototype.cloneAndGroupSelectedIn = function(ui) {
      var alreadyCloned, ignoreIds, selected,
        _this = this;

      selected = this.$el.find('[data-selected="1"]');
      alreadyCloned = ui.helper.find('.groups--owner');
      ignoreIds = [];
      alreadyCloned.each(function(iteration, ownerElement) {
        return ignoreIds.push($(ownerElement).data().userId);
      });
      return selected.each(function(iteration, el) {
        var clone, data, offset;

        el = $(el);
        data = el.data();
        if (!_.contains(ignoreIds, data.userId)) {
          clone = $(el).clone().removeAttr('id').attr('data-clone', 1);
          console.log(clone);
          el.append(clone);
          offset = $(el).offset();
          $(clone).offset(offset);
          return _this.animateMove(clone, ui);
        }
      });
    };

    Groups.prototype.maskElement = function(el) {
      var $el;

      $el = $(el);
      return $el.fadeTo('medium', 0.33);
    };

    Groups.prototype.unmaskElement = function(el) {
      var $el;

      $el = $(el);
      return $el.fadeTo(0, 1);
    };

    Groups.prototype.getOriginalFromClone = function(clone) {
      var data, original;

      data = clone.data();
      return original = $('#creator-' + data.userId);
    };

    Groups.prototype.initDraggables = function() {
      var _this = this;

      return this.$el.find('[data-behavior="draggable-user"]').draggable({
        containment: 'document',
        helper: 'clone',
        cursor: 'move',
        start: function(event, ui) {
          ui.helper.find('.groups--owner').each(function(iteration, clone) {
            var original;

            ui.helper.css({
              border: '1px solid blue'
            });
            clone = $(clone);
            clone.attr('data-clone', 1);
            original = _this.getOriginalFromClone(clone);
            _this.maskElement(original);
            _this.select(clone);
            return _this.select(original);
          });
          return _this.cloneAndGroupSelectedIn(ui);
        },
        stop: function(event, ui) {
          return ui.helper.find('.groups--owner').each(function(iteration, clone) {
            var original;

            clone = $(clone);
            original = _this.getOriginalFromClone(clone);
            _this.unselect(original);
            return _this.unmaskElement(original);
          });
        }
      });
    };

    Groups.prototype.initDroppables = function() {};

    Groups.prototype.render = function() {
      var context;

      context = {
        groups: this.groups.toJSON(),
        creators: this.creators.toJSON()
      };
      this.$el.html(this.template(context));
      this.initDraggables();
      return this.initDroppables();
    };

    return Groups;

  })(Vocat.Views.AbstractView);

}).call(this);
