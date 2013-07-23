(function() {
  define(['jquery_rails', './plugins'], function($) {
    return {
      bootstrap: function() {
        var e;

        try {
          Typekit.load({
            active: function() {
              return $('[data-behavior=alert]').each(function() {
                var alertHeight, alertTop;

                alertHeight = $(this).outerHeight();
                alertTop = (alertHeight / 2) - 14;
                return $(this).children('[data-behavior=alert-label]').css('top', alertTop);
              });
            }
          });
        } catch (_error) {
          e = _error;
        }
        return $(function() {
          $('[data-behavior="dropdown"]').dropdownNavigation();
          $('[data-behavior="sticky-header"]').stickyHeader();
          $('[data-behavior="shortcut-nav-toggle"]').shortcutNavigation();
          $('[data-behavior="help-overlay-toggle"]').helpOverlay();
          return $('.container').css('min-height', $(window).innerHeight() - $('.page-header').height() - 35);
        });
      }
    };
  });

}).call(this);
