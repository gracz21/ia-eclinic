# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'change', '#schedule_clinic_id', (evt) ->
    $.ajax '/doctors/:id/schedules/get_assignment_id_s',
      type: 'GET'
      dataType: 'script'
      data: {
        clinic_id: $("#schedule_clinic_id option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX assignment_id error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic get assignment_id OK!")