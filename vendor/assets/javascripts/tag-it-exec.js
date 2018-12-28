$(function(){
  var tag_list = $('#autocmplete_tag').val();
  var registered_tag_list = $('#registered_tag').val().split(' ');
  var autocomplete_tag_list = $('#autocomplete_tag').val().split(' ');
  $('#genre-tags').tagit();
  for (i = 0, len = registered_tag_list.length; i < len; i++) {
    $('#genre-tags').tagit('createTag', registered_tag_list[i]);
  }
  $('#genre-tags').tagit({availableTags: autocomplete_tag_list });
});
