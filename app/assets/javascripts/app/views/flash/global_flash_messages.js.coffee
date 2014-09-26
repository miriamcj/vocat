define (require) ->

  AbstractFlashMessages = require('views/abstract/abstract_flash_messages')
  template = require('hbs!templates/flash/global_flash_messages')

  class GlobalFlashMessages extends AbstractFlashMessages

    template: template

