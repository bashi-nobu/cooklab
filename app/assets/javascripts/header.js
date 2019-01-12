$(document).on('turbolinks:load', function(){
  $('.header').on("click","#navToggle, #overlay",function(e){
    $('.header').toggleClass('openNav');
    $("#overlay").fadeToggle(100);/*ふわっと表示*/
  });
});
