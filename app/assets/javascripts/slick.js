$(document).on('turbolinks:load', function() {
    var activeController = $('body').attr('data-controller');
    var activeAction = $('body').attr('data-action');
    if (activeController == 'top' && activeAction == 'index') {
      $('.slider-top').slick({
        // アクセシビリティ。左右ボタンで画像の切り替えをできるかどうか
        // accessibility: false,
        // // 自動再生。trueで自動再生される。
        autoplay: true,
        // // 自動再生で切り替えをする時間
        // autoplaySpeed: 3000,
        //  // 自動再生や左右の矢印でスライドするスピード
        // speed: 400,
        // // 自動再生時にスライドのエリアにマウスオンで一時停止するかどうか
        // pauseOnHover: false,
        // // 自動再生時にドットにマウスオンで一時停止するかどうか
        // pauseOnDotsHover: false,
        // 切り替えのアニメーション。ease,linear,ease-in,ease-out,ease-in-out
        cssEase: 'ease-in-out',
        // // 画像下のドット（ページ送り）を表示
        // dots: false,
        // // ドットのclass名をつける
        // dotsClass: 'dot-class',
        // // ドラッグができるかどうか
        // draggable: true,
        // // 切り替え時のフェードイン設定。trueでon
        fade: true,
        // スライドのエリアに画像がいくつ表示されるかを指定
        // slidesToShow: 1,
        // 一度にスライドする数
        // slidesToScroll: 1,
        // タッチスワイプに対応するかどうか
        swipe: true,
        // 表示中の画像を中央へ
        centerMode: true,
        focusOnSelect:true,
        // 前次ボタンを表示するか [初期値:true]
        arrows: false
      });
    }
});
