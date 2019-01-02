$(document).on('turbolinks:load', function() {
  $(".video__view__vimeo").on("click", "#video-pay-confirmation-btn", function(e){
    $("#video-overlay").stop().fadeToggle(500);
    $(".video-pay-frame").stop().fadeToggle(500);
  });
  $("body").on("click", "#video-overlay", function(e){
    $("#video-overlay").stop().fadeToggle(500);
    $(".video-pay-frame").stop().fadeToggle(500);
  });
  $('.video-pay-frame').on("click", "#video-pay-cancel", function(e){
    $("#video-overlay").stop().hide();
    $(".video-pay-frame").stop().hide();
  });
});
