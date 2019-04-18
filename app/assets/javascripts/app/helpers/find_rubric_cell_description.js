/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper('find_rubric_cell_description', function(cells, field, range, crop) {
  if (crop == null) { crop = 0; }
  const cell = cells.find(cell => (cell.field === field.id) && (cell.range === range.id));
  const desc = cell.description;
  if (crop > 0) { return desc.substr(0, crop - 1) + (desc.length > crop ? '...' : ''); } else { return desc; }
});