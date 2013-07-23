(function() {
  define('app/helpers/if_blank', ['handlebars'], function(Handlebars) {
    return Handlebars.registerHelper('if_blank', function(item, block) {
      if (item && item.replace(/\s/g, "").length) {
        return block.inverse(this);
      } else {
        return block.fn(this);
      }
    });
  });

}).call(this);
