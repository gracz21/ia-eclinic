# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'change', '#assignment_clinic_id', (evt) ->
    $.ajax 'doctor_options',
      type: 'GET'
      dataType: 'script'
      data: {
        clinic_id: $("#assignment_clinic_id option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")

$(document).on 'page:load ready', ->
  $("#appointment_day").datepicker(dateFormat: "dd.mm.yy", 
  minDate: new Date(), beforeShowDay: $.datepicker.noWeekends,
  firstDay: 1)
