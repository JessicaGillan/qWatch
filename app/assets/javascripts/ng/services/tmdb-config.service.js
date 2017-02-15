qWatch.factory('tmdbConfigService', [
  'Restangular', '$q',
  function(restangular, $q) {
    var _config = {};

    var _get = function _get() {
      return restangular
        .one('tmdb_config')
        .get()
        .then(function(config) {
          return _config = angular.copy(config);
        });
    }

    return {
    }
  }
]);
