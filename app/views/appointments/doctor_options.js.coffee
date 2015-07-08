$("#assignment_doctor_id").empty()
  .append("<%= escape_javascript(render(:partial => @doctors)) %>")