$(document).on('turbolinks:load', function() {
  var activeController = $('body').attr('data-controller');
  var activeAction = $('body').attr('data-action');
  if (activeController == 'contacts' && activeAction == 'confirm') {
    $(document).on('click','.contact-submit',function(e){
      $(this).prop('disabled', true).css("opacity", 0.6);
      $(this).parents('form').submit();
    });
  }
});
