qWatch.factory('showItemService', [
  'Restangular',
  function(Restangular){
    var _watchable = {};
    var SERVICES = [
                    "hulu", "amazon", "netflix", "xfinity", "amazon_buy",
                    "google_play", "itunes"
                   ]

    var get = function get(id){
      if(!_watchable.id || _watchable.id !== id){
        return Restangular
          .one('watchables', id)
          .get()
          .then(function(result){
            _combineUrls(_watchable, result)
            return _watchable;
          })
      }
      return $q.resolve(_watchable)
    }

    // PRIVATE

    var _combineUrls = function _combineUrls (watchable, result) {
      angular.copy(result, watchable);

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
      get: get
    }
  }
])
