define (require) ->

  AbstractFlashMessages = require('views/abstract/abstract_flash_messages')

  class FlashMessages extends AbstractFlashMessages

    # Not overrides, as of yet.
