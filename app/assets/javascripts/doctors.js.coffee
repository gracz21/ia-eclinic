# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:load ready', ->
  $("#get_day").datepicker(dateFormat: "yy-mm-dd", 
  minDate: new Date(), beforeShowDay: $.datepicker.noWeekends,
  firstDay: 1)
  
$ ->
  $(document).on 'change', '#get_day', (evt) ->
    $.ajax 'doctor_get_free_appointments',
      type: 'GET'
      dataType: 'script'
      data: {
        doctor_id: $("#doctor_id").val()
        day: $("#get_day").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX appointment error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic appointment load OK!")