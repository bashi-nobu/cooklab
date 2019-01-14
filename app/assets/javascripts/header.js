$(document).on('turbolinks:load', function(){
  $('body').on("click","#navToggle",function(e){
    $('.header').toggleClass('openNav');
    $("#overlay").fadeToggle(100);/*ふわっと表示*/
  });
  $('body').on("click","#overlay",function(e){
    $('.header').toggleClass('openNav');
    $("#overlay").fadeToggle(100);/*ふわっと表示*/
  });
});
