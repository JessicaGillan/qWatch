qWatch.controller('SignUpCtrl', [
  '$scope', 'userService',
  function($scope, user) {
    "use strict";

    $scope.userData = {};

    $scope.signUp = function (params) {
      console.log("signUp", params)
      // user.signUp(data);
    }

  }
]);
