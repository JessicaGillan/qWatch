qWatch.controller('ListShowCtrl',[
  '$scope', '$state', '$stateParams', '$rootScope', 'watchableService', 'tmdbConfigService',
  function($scope, $state, $stateParams, $root, watchableService, tmdbConfig){
    $root.showPage = true;
    
    $scope.currentItem = {};
    tmdbConfig().then(function(sizes){
      $scope.imageSizes = sizes;
    });
    watchableService.show($stateParams.id)
      .then( function (watchable) {
        $scope.watchable = watchable;
        $scope.currentItem.id = watchable.id
      });

    $root.$on('searchSet', function(event, term){
      $state.go('list', {searchSet: term}, {inherit: false})
    })

  }
])
