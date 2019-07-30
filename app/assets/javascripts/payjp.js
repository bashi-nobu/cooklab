$(document).on('turbolinks:load', function() {
  activeController = $('body').attr('data-controller');
  if (activeController == 'payments') {
    var PublicKey = $('#public_key').val();
    // ボタンのイベントハンドリング
    $(document).on('click','#token',function(e){
      $(this).prop('disabled', true).css("opacity", 0.6);
      var form = $(this).parents('form');
      var cc_number = $('#cc-number').val();
      var cc_csc = $('#cc-csc').val();
      var cc_exp = $('#cc-exp').val().split('/');
      var cc_holder = $('#cc-holder').val();
      if( cc_number != null && cc_csc != null && cc_holder != null && cc_exp.length == 2){
        e.preventDefault();
        // カード情報生成
        var card = {
          number: cc_number.replace(/\s/g,''),
          cvc: cc_csc,
          exp_month: parseInt(cc_exp[0]),
          exp_year: '20'+ cc_exp[1].replace(/\s/g,''),
          name: cc_holder
        };
        // トークン生成
        Payjp.setPublicKey(PublicKey);
        Payjp.createToken(card, function(status, response) {
          if (response.error) {
            alert('エラーが発生しました。お手数ですが再度登録ボタンをクリックしてください');
            
          } else {
            $('#payjp-token').val(response.id);
            form.submit();
          }
        });
      }else{
        alert('未入力の項目があります');
        $(this).prop('disabled', false).css("opacity", 1.0);
      }
    });
  }
});
