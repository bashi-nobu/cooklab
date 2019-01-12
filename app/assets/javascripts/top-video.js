$(document).on('turbolinks:load', function(){
  var activeController = $('body').attr('data-controller');
  var activeAction = $('body').attr('data-action');
  if (activeController == 'top' && activeAction == 'index') {
    var html = `<video src="assets/top.mp4" id="bg-video" autoplay loop muted></video>`;
    $('.main__logo').append(html);
  }
});
