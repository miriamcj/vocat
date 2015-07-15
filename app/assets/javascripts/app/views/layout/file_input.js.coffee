define ['jquery_rails'], ($) ->
  Marionette = require('marionette')

  class FileInputView extends Marionette.ItemView

    ui: {
      trigger: '[data-behavior="file-input-trigger"]'
      field: '[data-behavior="file-input-field"]'
      mask: '[data-behavior="file-input-mask"]'
    }

    triggers: {
      'click @ui.trigger': 'trigger:click'
      'change @ui.field': 'mask:update'
    }

    onMaskUpdate: () ->
      val = $(@ui.field).val()
      newVal = val.replace(/^C:\\fakepath\\/i, '')
      $(@ui.mask).val(newVal)

    onTriggerClick: () ->
      $(@ui.field).click()


