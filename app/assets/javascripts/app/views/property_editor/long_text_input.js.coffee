define (require) ->

  ShortTextInput = require('views/property_editor/short_text_input')
  template = require('hbs!templates/property_editor/long_text_input')

  class LongTextInput extends ShortTextInput

    template: template