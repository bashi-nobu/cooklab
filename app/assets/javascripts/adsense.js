document.addEventListener('turbolinks:load', function () {

  var ads = document.querySelectorAll('.adsbygoogle');

  if (ads.length > 0) {
    ads.forEach(function (ad) {
      if (ad.firstChild) {
        ad.removeChild(ad.firstChild);
      }
    });
    ads.forEach(function() {
      window.adsbygoogle = window.adsbygoogle || [];
      window.adsbygoogle.push({});
    });
  }
}