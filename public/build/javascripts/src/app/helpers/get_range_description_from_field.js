(function() {
  define('app/helpers/get_range_description_from_field', ['handlebars'], function(Handlebars) {
    return Handlebars.registerHelper('get_range_description_from_field', function(field, range, crop, options) {
      var desc;

      if (field.range_descriptions[range.id] != null) {
        desc = field.range_descriptions[range.id];
        if (crop > 0) {
          return desc.substr(0, crop - 1) + (desc.length > crop ? '...' : '');
        } else {
          return desc;
        }
      }
    });
  });

}).call(this);
