/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/truncate', ['handlebars'], Handlebars =>
  Handlebars.registerHelper('truncate', function(str, len) {
    let new_str;
    if (str.length > len) {
      new_str = str.substr(0, len + 1);
      while (new_str.length) {
        const ch = new_str.substr(-1);
        new_str = new_str.substr(0, -1);
        if (ch === ' ') {
          break;
        }
      }
      if (new_str === '') {
        new_str = str.substr(0, len);
      }
    } else {
      new_str = str;
    }
    return new_str + '...';
  })
);

