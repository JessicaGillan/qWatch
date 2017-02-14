qWatch.controller('ListIndexCtrl',[
  '$scope', '$rootScope', '$stateParams', 'watchableService', 'tmdbConfigService',
  function($scope, $root, $params, watchable, tmdbConfig){
    var setToIndex = function setToIndex(){
      $scope.list = $scope.watchables;
    }

    watchable.index().then(function setWatchable(watchables) {
      $scope.watchables = watchables;
      setToIndex();
    });

    $root.$on('searchSet', function(event, term){
      watchable.search(term).then(function(searchResults){
        $scope.list = searchResults
      })
    });

    $root.$on('searchClear', setToIndex);

    $scope.posterUrl = function(poster) {
      var url;
      tmdbConfig.configUrl()
        .then(function(config) {
          url = config + poster;
        })
      return url;
    }
  }
])
