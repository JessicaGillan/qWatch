qWatch.controller('ListShowCtrl',[
  '$scope', '$stateParams', 'showItemService',
  function($scope, $stateParams, showItemService){

    showItemService.get($stateParams.id)
    .then( function (watchable) {
      $scope.watchable = watchable;
    })

    $scope.copyLink = function() {
      return 'http://localhost:3000/#!/watch/' + $stateParams.id
    }
  }
])
