define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/admin/enrollment_view')
  CreatorEnrollmentItem = require('views/admin/creator_enrollment_item')
  require('jquery_ui')

  class CreatorEnrollment extends Marionette.CompositeView

    template: template
    itemViewContainer: "tbody",
    itemView: CreatorEnrollmentItem

    ui: {
      studentInput: '[data-behavior="student-input"]'
    }

    initialize: () ->
      @collection.fetch()

    onRender: () ->
      @ui.studentInput.chosen({width: "95%"})
      input = @$el.find('.chosen-search input')
      console.log  input.length, 'l'
      $(input).autocomplete({
        source: (request, response) =>
          $.ajax({
            url: "/api/v1/courses/#{@collection.courseId}/creators/search?last_name=#{request.term}"
            dataType: "json"
            beforeSend: () ->
              console.log 'before send'
              $('ul.chzn-results').empty()
            success: (data) ->
              response( $.map( data, (item) ->
                $('ul.chzn-results').append('<li class="active-result">' + item.name + '</li>')
              ))
          })
      })
