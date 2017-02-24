var $_ = $_ || function Helper(){};
$_.x = function () {
  if (typeof XMLHttpRequest !== 'undefined') {
    return new XMLHttpRequest();
  }
  var versions = [
    "MSXML2.XmlHttp.6.0",
    "MSXML2.XmlHttp.5.0",
    "MSXML2.XmlHttp.4.0",
    "MSXML2.XmlHttp.3.0",
    "MSXML2.XmlHttp.2.0",
    "Microsoft.XmlHttp"
  ];

  var xhr;
  for (var i = 0; i < versions.length; i++) {
    try {
      xhr = new ActiveXObject(versions[i]);
      break;
    } catch (e) {
    }
  }
  return xhr;
};

$_.send = function (url, callback, method, data, async) {
  if (async === undefined) {
    async = true;
  }
  var x = $_.x();
  x.open(method, url, async);
  x.onreadystatechange = function () {
    if (x.readyState == 4 && callback) {
      callback(x.responseText)
    }
  };
  if (method == 'POST') {
    x.setRequestHeader('Content-type', 'application/json');
  }
  x.send(data)
};

var qWatchNetflix = function qWatchNetflix(){
  var videos, video, collection = [];
  var _decodeHtml = function _decodeHtml(html) {
    var txt = document.createElement("textarea");
    txt.innerHTML = html;
    return txt.value;
  }

  var _loopAttributes = function(attributes, target){
    for(var a = 0, aLen = attributes.length; a < aLen; a++){
      if(attributes[a].name === target){
        return attributes[a].value;
      }
    }
  }

  var _getVideos = function _getVideos(){
    videos = document.getElementsByClassName('title_card');
    for(var i = 0, length = videos.length; i < length; i++){
      video = videos[i];
      var item = {}
      item.title = _loopAttributes(video.attributes, "aria-label")
      var info = video.querySelector('.ptrack-content')
      item.url = "https://netflix.com/watch/" + JSON.parse(decodeURIComponent(_loopAttributes(info.attributes, "data-ui-tracking-context"))).video_id

      collection.push(item);
    }
    var sendIt = {watchables: collection, service: "netflix"}
    $_.send("https://localhost:3001/api/v1/data", null, 'POST', JSON.stringify(sendIt))
    // $_.send("https://qwatch.me/api/v1/data", null, 'POST', collection)
  }

  _getVideos();
  return collection
}

function addShareButton(){
  var statusBar, qWatchLink, qWatchLogo;

  function addqWatchLogo(){
    qWatchLink = document.createElement("A");
    qWatchLogo = document.createElement("SPAN");

    qWatchLink.classList.add("qwatch-logo");
    qWatchLink.classList.add("player-control-button");
    qWatchLogo.innerHTML = "qW";
    qWatchLink.appendChild(qWatchLogo);
    statusBar.appendChild(qWatchLink);
  }

  function grabTitle (){
    return statusBar.querySelector('.player-status-main-title').innerHTML
  }

  function addqWatchListener(){
    qWatchLink.target = "_blank";
    qWatchLink.href = "https://qwatch.me/#!/share?title=" + grabTitle();
  }

  function statusBarReady(){

    if(!(statusBar = document.querySelector('.player-status'))){
      return setTimeout(statusBarReady, 100);
    }
    addqWatchLogo();
    addqWatchListener();
  }

  statusBarReady();

}

var indexHandler, mined, currentLocation = location.pathname;

function runScript(){
  clearTimeout(indexHandler);
  if(currentLocation.match(/.*browse.*/)){
    if(!mined) indexHandler = setTimeout(function(){
      qWatchNetflix();
      mined = true;
    }, 10000)
  } else if(currentLocation.match(/.*watch.*/)) {
    addShareButton();
  }
}

runScript()

setInterval(function(){
  if(currentLocation !== location.pathname){
    currentLocation = location.pathname
    runScript()
  }
})
