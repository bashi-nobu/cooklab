$(document).on('turbolinks:load', function(){
  function buildFirstSeriesList(suggest) {
    var html = `<li class="suggest"><span><i class="fa fa-search"></i>動画シリーズ</span></li>`;
    return html;
  }
  function buildFirstGenreList(suggest) {
    var html = `<li class="suggest"><span><i class="fa fa-search"></i>動画ジャンル</span></li>`;
    return html;
  }
  function buildFirstChefGenreList(suggest) {
    var html = `<li class="suggest"><span><i class="fa fa-search"></i>専門分野</span></li>`;
    return html;
  }
  function buildSeriesList(suggest) {
    var html = `<li class="series-suggest" data-keyword="${ suggest.suggest_series }" >${ suggest.suggest_series }</li>
                `;
    return html;
  }
  function buildGenreList(suggest) {
    var html = `<li class="genre-suggest" data-keyword="${ suggest.suggest_genre }" >${ suggest.suggest_genre }</li>
                `;
    return html;
  }
  function buildChefGenreList(suggest) {
    var html = `<li class="chef-genre-suggest" data-keyword="${ suggest.suggest_chef_genre }" >${ suggest.suggest_chef_genre }</li>
                `;
    return html;
  }

  //インクリメンタルサーチ処理
  var activeController = $('body').attr('data-controller');
  var activeAction = $('body').attr('data-action');
  if (activeController == 'video' && (activeAction == 'chef_search' || activeAction == 'chef_search_video')) {
    $('#search-field').on('keyup compositionend', function(e){
      e.preventDefault();
      var inputData = $(this).val();
      if(inputData.length > 1){
        $.ajax({
          type: "GET",
          url: '/video/make_suggest?search_patarn=chef-search',
          data: {
            search_word: inputData
          },
          dataType: 'json',
        })
        //ajax処理が成功した場合の処理
        .done(function(data_list) {
          $('.suggest_chef_genre_list').empty();
          $('.search-window__suggest').show();
          var chef_suggest_check = 'off';
          data_list.forEach(function(suggest){
            if(suggest.suggest_chef_genre && chef_suggest_check == 'off'){
              html = buildFirstChefGenreList(suggest);
              $('.suggest_chef_genre_list').append(html);
              chef_suggest_check = 'on'
            }
            if(suggest.suggest_chef_genre){
              html = buildChefGenreList(suggest);
              $('.suggest_chef_genre_list').append(html);
            }
          });
        })
      }else{
        $('.suggest_chef_genre_list').empty();
      }
      $(document).on("click", ".chef-genre-suggest", function (e) {
        var search_genre = $(this).attr('data-keyword');
        $('#search-field').val(search_genre);
        $('#suggest_patarn').val('chef_genre');
        $('.search-form').submit();
      });
    });
  }else if(activeController == 'video'){
    $('#search-field').on('keyup compositionend', function(e){
      e.preventDefault();
      var inputData = $(this).val();
      if(inputData.length > 1){
        $.ajax({
          type: "GET",
          url: '/video/make_suggest?search_patarn=chef_search',
          data: {
            search_word: inputData
          },
          dataType: 'json',
        })
        //ajax処理が成功した場合の処理
        .done(function(data_list) {
          $('.suggest_series_list').empty();
          $('.suggest_genre_list').empty();
          $('.search-window__suggest').show();
          var series_suggest_check = 'off';
          var genre_suggest_check = 'off';
          data_list.forEach(function(suggest){
            if(suggest.suggest_series && series_suggest_check == 'off'){
              html = buildFirstSeriesList(suggest);
              $('.suggest_series_list').append(html);
              series_suggest_check = 'on'
            }
            if(suggest.suggest_genre && genre_suggest_check == 'off'){
              html = buildFirstGenreList(suggest);
              $('.suggest_genre_list').append(html);
              genre_suggest_check = 'on'
            }
            if(suggest.suggest_series){
              html = buildSeriesList(suggest);
              $('.suggest_series_list').append(html);
            }
            if(suggest.suggest_genre){
              html = buildGenreList(suggest);
              $('.suggest_genre_list').append(html);
            }
          });
        })
      }else{
        $('.suggest_series_list').empty();
        $('.suggest_genre_list').empty();
      }
    });

    //サジェストを押された際の処理
    $(document).on("click", ".series-suggest", function (e) {
      var search_series = $(this).attr('data-keyword');
      $('#search-field').val(search_series);
      $('#suggest_patarn').val('series');
      $('.search-form').submit();
    });
    $(document).on("click", ".genre-suggest", function (e) {
      var search_genre = $(this).attr('data-keyword');
      $('#search-field').val(search_genre);
      $('#suggest_patarn').val('genre');
      $('.search-form').submit();
    });
  }
});
