$(document).on('turbolinks:load', function() {
  $(".video-pay-frame").on("click", "#video-pay-btn", function(e){
    $(this).prop('disabled', true).css("opacity", 0.6);
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
        alert('通信エラー');
        $(this).prop('disabled', false).css("opacity", 1.0);
      }else{
        location.reload();
      }
    });
  });
});
