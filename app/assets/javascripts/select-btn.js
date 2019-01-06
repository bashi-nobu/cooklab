$(document).on('turbolinks:load', function(){
  $('.select-btn').on('change', function(e){
    $('#select-form').submit();
  });

  $('.order-select-btn').on('change', function(e){
    // var order = $(this).val();
    // alert(order);
    $('#order-select').submit();
  });
});
