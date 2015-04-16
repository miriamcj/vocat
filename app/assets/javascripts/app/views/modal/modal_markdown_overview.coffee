define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/modal/modal_markdown_overview')

  class ModalMarkdownOverview extends Marionette.ItemView

    template: template
    modalWidth: '90%'
    modalMaxWidth: '800'

    triggers: {
      'click [data-behavior="dismiss"]': 'click:dismiss'
    }

    onKeyUp: (e) ->
      code = if e.keyCode? then e.keyCode else e.which
      if code == 27 then @onClickDismiss()

    onClickDismiss: () ->
      Vocat.vent.trigger('modal:close')

    onDestroy: () ->
      $(window).off('keyup', @onKeyUp)

    initialize: (options) ->
      _.bindAll(@, 'onKeyUp');
      $(window).on('keyup', @onKeyUp)
