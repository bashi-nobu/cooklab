$(document).on('turbolinks:load', function(){
  $('body').on("click","#navToggle, #overlay",function(e){
    alert('aaaaaa');
    // $('.header').toggleClass('openNav');
    $("#overlay").fadeToggle(100);/*ふわっと表示*/
  });
});
