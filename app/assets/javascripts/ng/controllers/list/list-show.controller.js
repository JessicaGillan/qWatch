qWatch.controller('ListShowCtrl',[
  '$scope', '$stateParams', 'watchableService',
  function($scope, $stateParams, watchableService){
    console.log("shown");
    watchableService.show($stateParams.id)
      .then( function (watchable) {
        $scope.watchable = watchable;
      });
  }
])
