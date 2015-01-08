define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/player/image_displayer')

  class ImageDisplayerView extends Marionette.ItemView

    template: template

