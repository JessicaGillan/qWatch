qWatch.controller('ListShowCtrl',[
  '$scope', '$rootScope', '$stateParams', 'watchableService',
  function($scope, $root, $stateParams, watchableService){
    $root.showPage = true;

    watchableService.show($stateParams.id)
      .then( function (watchable) {
        $scope.watchable = watchable;
      });
  }
])
