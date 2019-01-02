$(document).on('turbolinks:load', function() {
  $(".video-pay-frame").on("click", "#video-pay-btn", function(e){
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
