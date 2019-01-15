$(document).on('turbolinks:load', function(){
    var e = $("#refreshed").val();
    if(e == "no"){
      $("#refreshed").val("yes");
    }else{
      $("#refreshed").val("no");
      location.reload();
    }
});
