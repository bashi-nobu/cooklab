$(document).on('turbolinks:load', function() {
  $(document).on('change','input[name="concent"]',function(e){
    if($('input[name="concent"]').prop('checked')){
      $('.disable').hide();
      $('.able').show();
    }else{
      $('.able').hide();
      $('.disable').show();
    }
  })
});


