document.addEventListener('turbolinks:load', function() {
    $('body').on("click",".header__search-icon",function(e){
    	$('.search-frame').fadeToggle(100);/*ふわっと表示*/
		$(this).hide();
		$('.header__search-close-icon').show();
    });

    $('body').on("click",".search-btn",function(e){
    	$('.search-frame').fadeToggle(100);/*ふわっと表示*/
    });

    $('body').on("click",".header__search-close-icon",function(e){
    	$('.search-frame').fadeToggle(100);/*ふわっと表示*/
		$(this).hide();
		$('.header__search-icon').show();
    });

	$('.search-frame').on("click",".genre-tag",function(e){
		if($(this).attr('class') == 'genre-tag'){
			$(this).addClass('selected-genre-tag');
			$(this).find('input[name="search_genre_id[]"]').prop('checked', true);
			$(this).find('input[name="search_genre_name[]"]').prop('checked', true);
		}else{
			$(this).removeClass('selected-genre-tag');
			$(this).find('input[name="search_genre_id[]"]').prop('checked', false);
			$(this).find('input[name="search_genre_name[]"]').prop('checked', false);
		}
    });

    $('.search-frame').on("click",".series-tag",function(e){
		if($(this).attr('class') == 'series-tag'){
			$(this).addClass('selected-series-tag');
			$(this).find('input[name="search_series_id[]"]').prop('checked', true);
			$(this).find('input[name="search_series_title[]"]').prop('checked', true);
		}else{
			$(this).removeClass('selected-series-tag');
			$(this).find('input[name="search_series_id[]"]').prop('checked', false);
			$(this).find('input[name="search_series_title[]"]').prop('checked', false);
		}
    });

    $('.search-frame').on("click",".topic-tag",function(e){
    	if($(this).attr('class') == 'topic-tag'){
			$(this).addClass('selected-topic-tag');
			$(this).find('input:hidden[name="search_chef_id[]"]').prop('checked', true);
			$(this).find('input:hidden[name="search_chef_name[]"]').prop('checked', true);
		}else{
			$(this).removeClass('selected-topic-tag');
			$(this).find('input:hidden[name="search_chef_id[]"]').prop('checked', false);
			$(this).find('input:hidden[name="search_chef_name[]"]').prop('checked', false);
		}	
    });

    $('.search-frame').on("click",".video-search-submit",function(e){
		$('.video-search-form').submit();
 	});

 	$('.search-frame').on("click",".article-search-submit",function(e){
		$('.article-search-form').submit();
 	});    
});
