$("#appointment_hour").empty()
  .append("<%= escape_javascript(render(:partial => 'appointments/hour', :locals => { :hours => @hours })) %>")