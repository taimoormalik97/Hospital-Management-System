function set_domain(){
  $("#hospital_name").keyup(function(){
    var SubDomain = $("#hospital_name").val();
    SubDomain = SubDomain.toLowerCase().replace(/\s/g, "");
    $("#sub_domain").val(SubDomain);
  });
}

$(document).ready(set_domain)
