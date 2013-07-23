(function() {
  define('app/helpers/each_property', ['handlebars'], function(Handlebars) {
    return Handlebars.registerHelper("each_property", function(context, options) {
      var high, ret;

      if (options.hash.high != null) {
        high = parseInt(options.hash.high);
      }
      ret = "";
      _.each(context, function(value, prop) {
        var per, val;

        val = context[prop];
        if ((high != null) && (value != null)) {
          per = parseInt(parseFloat(value / high) * 100);
        } else {
          per = null;
        }
        return ret = ret + options.fn({
          property: prop,
          value: value,
          per: per
        });
      });
      return ret;
    });
  });

}).call(this);
