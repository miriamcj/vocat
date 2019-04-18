/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper("join", function(value, options) {

  // Clone it.
  value = value.slice(0);

  const separator = options.hash.separator || ', ';
  const lastSeparator = options.hash.lastSeparator || 'and ';
  const leadingIndefiniteArticle = options.hash.leadingIndefiniteArticle || false;
  const capitalize = options.hash.capitalize || false;

  if (_.isArray(value)) {

    let last;
    if (capitalize) {
      value = _.map(value, theString => theString.charAt(0).toUpperCase() + theString.slice(1));
    }

    const { length } = value;

    if (length > 1) {
      last = value.pop();
    }

    let out = value.join(separator);

    if (length === 2) {
      out = out + ' ' + lastSeparator + last;
    }
    if (length > 2) {
      out = out + separator + lastSeparator + last;
    }

    if (leadingIndefiniteArticle === true) {
      let article;
      const first = out[0].toLowerCase();
      if ((first === 'a') || (first === 'e') || (first === 'i') || (first === 'o') || (first === 'u') || (first === 'y')) {
        article = 'an';
      } else {
        article = 'a';
      }
      out = `${article} ${out}`;
    }

    return out;

  } else {
    return value;
  }
});
