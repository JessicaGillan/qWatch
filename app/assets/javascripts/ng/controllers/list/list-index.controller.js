qWatch.controller('ListIndexCtrl',[
  '$scope', '$rootScope', '$stateParams', 'watchableService',
  function($scope, $root, $params, watchable){
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
  }
])
