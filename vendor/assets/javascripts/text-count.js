$(function(){
    $('#article-contents').bind('keydown keyup keypress change',function(){
        var txt = $(this).val(),
            new_txt = $.trim(txt.replace(/\n/g, "")),
            couter = new_txt.length;
        $('#text-count').html(couter);
    });
});
