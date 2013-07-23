(function() {
  define(['vendor/plugins/waypoints', 'jquery_rails'], function(waypoints, $) {
    $.fn.extend({
      dropdownNavigation: function(options) {
        var settings;

        settings = {};
        settings = $.extend(settings, options);
        return this.each(function() {
          var $container, $toggle;

          $container = $(this);
          $toggle = $container.find('[data-behavior="toggle"]');
          $(document).click(function() {
            return $container.removeClass('open');
          });
          return $toggle.click(function(event) {
            event.preventDefault();
            if ($container.hasClass('open')) {
              $container.removeClass('open');
              return event.stopPropagation();
            } else {
              $container.addClass('open');
              return event.stopPropagation();
            }
          });
        });
      }
    });
    $.fn.extend({
      stickyHeader: function(options) {
        var $el, settings;

        $el = $(this);
        if (options === 'destroy') {
          $el.waypoint('destroy');
          return $el;
        } else {
          settings = {};
          settings = $.extend(settings, options);
          return this.each(function() {
            return $el.waypoint(function(direction) {
              if (direction === "down") {
                $el.addClass('stuck');
              }
              if (direction === "up") {
                return $el.removeClass('stuck');
              }
            });
          });
        }
      }
    });
    $.fn.extend({
      shortcutNavigation: function(options) {
        var $nav, settings;

        settings = {};
        settings = $.extend(settings, options);
        $nav = $('.js-shortcut-nav');
        setTimeout(function() {
          return $nav.removeClass('invisible');
        }, 500);
        return this.each(function() {
          var $el;

          $el = $(this);
          return $el.click(function(event) {
            $el.toggleClass('active');
            $nav.toggleClass('visible');
            return event.preventDefault();
          });
        });
      }
    });
    return $.fn.extend({
      helpOverlay: function(options) {
        var settings;

        settings = {};
        settings = $.extend(settings, options);
        return this.each(function() {
          var $toggle, state;

          $toggle = $(this);
          state = $toggle.is(':checked');
          if (state === true) {
            $toggle.parents('label').addClass('active');
          }
          return $toggle.click(function() {
            return $(this).parents('label').toggleClass('active');
          });
        });
      }
    });
  });

}).call(this);
