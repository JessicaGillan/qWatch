qWatch.factory('tmdbConfigService', [
  '$q', '_', 'Restangular',
  function($q, _, restangular) {
    "use strict";

    var _config = {}, _sizes = {};

    var _extract = function _extract(config){
      _config.url = config.url.replace("http://", "//");
      _config.sizes = {}
      for(var i = 0, length = config.sizes.length; i < length; i++){
        _config.sizes[config.sizes[i]] = config.sizes[i];
      }
      return _config;
    }

    var _get = function _get() {
      if(_.isEmpty(_config)){
        return restangular
        .one('tmdb_config')
        .get()
        .then(function(config) {
          return _extract(config)
        });
      }

      return $q.resolve(_config);
    }

    var _getSizes = function _getSizes(){
      if(_.isEmpty(_sizes)){
        angular.copy({
          small: _config.url + _config.sizes.w300,
          medium: _config.url + _config.sizes.w500,
          large: _config.url + _config.sizes.w780,
          desktop: _config.url + _config.sizes.w1280,
          original: _config.url + _config.sizes.desktop,
        }, _sizes);
      }
      return _sizes;
    }

    var sizes = function sizes(){
      if(_.isEmpty(_config)){
        return _get().then(function(){
          return _getSizes();
        })
      }
      return $q.resolve(_getSizes());
    }


    return sizes
  }
]);
