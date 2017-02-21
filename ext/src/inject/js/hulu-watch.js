(function(){
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

})();
