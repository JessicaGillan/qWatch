qWatch.controller('NavCtrl', [
  '$scope', '$state', '$rootScope', '$timeout',
  function($scope, $state, $root, $timeout) {
    "use strict";

    $scope.goToIndex = function goToIndex(){
      // $state.go('list', {}, {reload: true})
      location.href = "/"
    }

  }
]);
