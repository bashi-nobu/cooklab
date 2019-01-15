$(document).on('turbolinks:load', function(){
  $('input').on('keypress',function (e) {
    if (e.which == 13 && $(this).attr('class') != "s-window") {
      return false;
    }
  });
});
