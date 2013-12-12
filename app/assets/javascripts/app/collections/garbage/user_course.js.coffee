define ['backbone'], (Backbone) ->
  class UserCourseModel extends Backbone.Model

    userId: null

    isNew: () ->
      true

    destroy: (options) ->
      isNew = @isNew
      @isNew = () -> false
      xhr = super(options)
      @isNew = isNew
      return xhr

    setEnrollmentId: (id) ->
      @userId = id
