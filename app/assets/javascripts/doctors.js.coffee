# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
  
$ ->
  $(document).on 'change', '#doc_day', (evt) ->
    $.ajax 'doctor_get_free_appointments',
      type: 'GET'
      dataType: 'script'
      data: {
        doctor_id: $("#doctor_id").val()
        day: $("#doc_day").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX appointment error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic appointment load OK!")