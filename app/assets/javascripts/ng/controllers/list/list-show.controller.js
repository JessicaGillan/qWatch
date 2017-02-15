qWatch.controller('ListShowCtrl',[
  '$scope', '$state', '$stateParams', '$rootScope', 'watchableService',
  function($scope, $state, $stateParams, $root, watchableService){
    watchableService.show($stateParams.id)
      .then( function (watchable) {
        $scope.watchable = watchable;
      });

    // $root.$on('searchSet', function() {
    //   $state.go('list');
    // })
  }
])
