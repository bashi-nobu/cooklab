$(document).on('turbolinks:load', function(){
  // $(document).on('click','#like_count_btn',function(e){
  $("#like_count_btn").on("click",function(){
    $('.share-frame__like-btn').off('click');
    $('.share-frame__like-btn').on('click','#like_count_btn',function(e){
      alert("お気に入り登録の上限数を超えています！");
      return false;
    });
  });
});