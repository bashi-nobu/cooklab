$(document).on('turbolinks:load', function(){
  var activeController = $('body').attr('data-controller');
  var activeAction = $('body').attr('data-action');
  var windowWidth = $(window).width();
  if (activeController == 'top' && activeAction == 'index' && windowWidth > 930) {
    $('.top-slide').remove();
    $('.main__logo').css('padding-top','40%');
    var html = '<div id="top_bg_video" class="player" data-property="{videoURL:\'https://player.vimeo.com/video/316066968\',containment:\'.main__logo\',autoPlay:true, mute:true, startAt:0, opacity:1, showControls:false}"></div>';
    $('.main__logo').append(html);
    $('#top_bg_video').vimeo_player();
  }
});
