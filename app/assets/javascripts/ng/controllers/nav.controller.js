qWatch.controller('NavCtrl', [
  '$scope', '$state', '$rootScope', '$timeout',
  function($scope, $state, $root, $timeout) {

    $scope.goToIndex = function goToIndex(){
      $state.go('list', {}, {reload: true})
    }

  }
]);
