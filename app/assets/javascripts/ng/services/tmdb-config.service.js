qWatch.factory('tmdbConfigService', [
  'Restangular',
  function(restangular) {
    var configUrl = function url() {
      return restangular
        .all('tmdb_config')
        .getList()
        .then(function(config) {
          return config;
        })
    }

    return {
      configUrl: configUrl
    }
  }
]);
