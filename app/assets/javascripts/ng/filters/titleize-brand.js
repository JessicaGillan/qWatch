qWatch.filter('titleizeBrand', function() {
  "use strict";
  
  var serviceTitles = {
    "hulu": "Hulu",
    "amazon": "Amazon",
    "netflix": "Netflix",
    "xfinity": "Xfinity",
    "amazon_buy": "Amazon Buy",
    "google_play": "Google Play",
    "itunes": "iTunes"
  }

  return function(name) {
    if (serviceTitles[name])  return serviceTitles[name];
    return name
  }
});
