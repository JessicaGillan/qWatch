qWatch.factory('showItemService', [
  'Restangular',
  function(restangular){
    "use strict";
    
    var SERVICES = [
                    "hulu", "amazon", "netflix", "xfinity", "amazon_buy",
                    "google_play", "itunes"
                   ]

    // PRIVATE
    var combineUrls = function combineUrls (watchable) {

      var services = []
      for (var i = 0; i < SERVICES.length; i++) {
        if (watchable[SERVICES[i]]) {
          services.push(_getServiceObj(SERVICES[i], watchable[SERVICES[i]]))
        }
      }

      watchable.services = services
    }

    var _getServiceObj = function _getServiceObj(service, link) {
      return {
        name: service,
        link: link
      }
    }

    return {
      combineUrls: combineUrls
    }
  }
])
