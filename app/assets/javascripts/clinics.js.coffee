# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'change', '#clin_day', (evt) ->
    $.ajax 'clinic_get_free_appointments',
      type: 'GET'
      dataType: 'script'
      data: {
        clinic_id: $("#clinic_id").val()
        day: $("#clin_day").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX appointment error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic appointment load OK!")