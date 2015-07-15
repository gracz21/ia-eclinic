# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'change', '#appointment_assignment_clinic_id', (evt) ->
    $.ajax 'doctor_options',
      type: 'GET'
      dataType: 'script'
      data: {
        clinic_id: $("#appointment_assignment_clinic_id option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX clinic error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic clinic select OK!")

$(document).on 'page:load ready', ->
  $("#appointment_day").datepicker(dateFormat: "dd.mm.yy", 
  minDate: new Date(), beforeShowDay: $.datepicker.noWeekends,
  firstDay: 1)
  
$ ->
  $(document).on 'change', '#appointment_day', (evt) ->
    $.ajax 'hour_options',
      type: 'GET'
      dataType: 'script'
      data: {
        clinic_id: $("#appointment_assignment_clinic_id option:selected").val()
        doctor_id: $("#appointment_assignment_doctor_id option:selected").val()
        day: $("#appointment_day").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX appointment error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic appointment select OK!")
