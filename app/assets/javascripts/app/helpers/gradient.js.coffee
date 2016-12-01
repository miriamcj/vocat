define 'app/helpers/gradient', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper "gradient", (start, stop, percentage) ->
    hexToRgb = (hex) ->
      result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
      return null unless result
      rbg = {r: parseInt(result[1], 16), g: parseInt(result[2], 16), b: parseInt(result[3], 16)}

    rbgToHex = (rgb) ->
      hex = "#" + ((1 << 24) + (rgb.r << 16) + (rgb.g << 8) + rgb.b).toString(16).slice(1)

    startRgb = hexToRgb(start)
    stopRgb = hexToRgb(stop)

    percentColors = [
      {percent: 0.0, color: {r: startRgb.r, g: startRgb.g, b: startRgb.b}},
      {percent: 1.0, color: {r: stopRgb.r, g: stopRgb.g, b: stopRgb.b}}
    ]

    lower = percentColors[0]
    upper = percentColors[percentColors.length - 1]
    range = upper.percent - lower.percent
    percentageUpper = percentage - lower.percent/range
    percentageLower = 1 - percentageUpper
    gradientColor = {
      r: Math.floor(lower.color.r * percentageLower + upper.color.r * percentageUpper),
      g: Math.floor(lower.color.g * percentageLower + upper.color.g * percentageUpper),
      b: Math.floor(lower.color.b * percentageLower + upper.color.b * percentageUpper),
    }

    rbgToHex(gradientColor)

