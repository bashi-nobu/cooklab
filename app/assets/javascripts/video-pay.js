$(document).on('turbolinks:load', function() {
  $(document).on("click", "#video-pay-confirmation-btn, #video-overlay", function(e){
    $("#video-overlay").fadeToggle(0);
    $(".video-pay-frame").fadeToggle(0);
  });
  $(document).on("click", "#video-pay-cancel", function(e){
    $("#video-overlay").hide();
    $(".video-pay-frame").hide();
  });

  $(document).on("click", "#video-pay-btn", function(e){
    var video_id = $(this).attr('data-video-num');
    var price = $(this).attr('data-video-price');
    // 支払処理
    $.ajax({
      type: "POST",
      url: '/payments/purchase_charge',
      data: {
        video_id: video_id,
        price: price
      },
      dataType: 'json',
    })
    // ajax処理が成功した場合の処理
    .done(function(charge_result) {
      if(charge_result == 'error'){
        alert('エラー');
      }else{
        location.reload();
      }
    });
  });
});
