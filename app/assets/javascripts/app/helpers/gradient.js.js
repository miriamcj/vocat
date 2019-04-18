/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/gradient', ['handlebars'], Handlebars =>
  Handlebars.registerHelper("gradient", function(start, stop, percentage) {
    const hexToRgb = function(hex) {
      let rbg;
      const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
      if (!result) { return null; }
      return rbg = {r: parseInt(result[1], 16), g: parseInt(result[2], 16), b: parseInt(result[3], 16)};
    };

    const rbgToHex = function(rgb) {
      let hex;
      return hex = `#${((1 << 24) + (rgb.r << 16) + (rgb.g << 8) + rgb.b).toString(16).slice(1)}`;
    };

    const startRgb = hexToRgb(start);
    const stopRgb = hexToRgb(stop);

    const percentColors = [
      {percent: 0.0, color: {r: startRgb.r, g: startRgb.g, b: startRgb.b}},
      {percent: 1.0, color: {r: stopRgb.r, g: stopRgb.g, b: stopRgb.b}}
    ];

    const lower = percentColors[0];
    const upper = percentColors[percentColors.length - 1];
    const range = upper.percent - lower.percent;
    const percentageUpper = percentage - (lower.percent/range);
    const percentageLower = 1 - percentageUpper;
    const gradientColor = {
      r: Math.floor((lower.color.r * percentageLower) + (upper.color.r * percentageUpper)),
      g: Math.floor((lower.color.g * percentageLower) + (upper.color.g * percentageUpper)),
      b: Math.floor((lower.color.b * percentageLower) + (upper.color.b * percentageUpper)),
    };

    return rbgToHex(gradientColor);
  })
);

