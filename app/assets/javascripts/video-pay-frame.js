$(document).on('turbolinks:load', function() {
  $(".video__view__vimeo").on("click", "#video-pay-confirmation-btn", function(e){
    $("#video-overlay").stop().fadeToggle(300);
    $(".video-pay-frame").stop().fadeToggle(300);
  });
  $("body").on("click", "#video-overlay, #video-pay-cancel", function(e){
    $("#video-overlay").stop().fadeToggle(300);
    $(".video-pay-frame").stop().fadeToggle(300);
  });
});
