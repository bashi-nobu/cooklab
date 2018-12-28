$(function(){
  var videoCrudPatarn = $('#videoCrudPatarn').val();
  if (videoCrudPatarn == 'edit'){
    var series_video_count = parseInt( $( 'option:selected', '#series_id').attr('video-count') );
    var $options = $('option','#video_orders');
    for (var i=0; i < $options.length; i++) {
      $options.eq(i).show()
      if( parseInt($options.eq(i).val()) > series_video_count ){
        $options.eq(i).hide()
      }
    }
  }
  $(document).on('change', '#series_id', function() {
    var series_video_count = parseInt($('option:selected', this).attr('video-count')) + 1;
    var $options = $('option','#video_orders');
    for (var i=0; i < $options.length; i++) {
      $options.eq(i).show()
      if( parseInt($options.eq(i).val()) > series_video_count ){
        $options.eq(i).hide()
      }
    }
  });
});
