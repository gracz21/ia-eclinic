$("#appointments_table").empty()
  .append("<%= escape_javascript(render(:partial => 'doctors/free_appointments_table', 
    :locals => { :hours => @hours, :clinic_names => @clinic_names })) %>")