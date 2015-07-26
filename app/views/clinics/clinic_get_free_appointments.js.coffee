$("#appointments_table").empty()
  .append("<%= escape_javascript(render(:partial => 'shared/free_appointments_table', 
    :locals => { :hours => @hours, :clinic_names => @clinic_names, :doctors => @doctors })) %>")