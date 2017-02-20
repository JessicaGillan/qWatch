qWatch.controller('NavCtrl', [
  '$scope', '$state', '$rootScope', '$timeout', 'userService',
  function($scope, $state, $root, $timeout, user) {
    "use strict";

    $scope.userData = {};

    $scope.goToIndex = function goToIndex(){
      // $state.go('list', {}, {reload: true})
      location.href = "/"
    }

    $scope.signedInUser = function () {
      var signedIn = user.signedInUser();
      return signedIn
    }

    $scope.signIn = function (valid) {
      if (valid) {
        user.signIn($scope.userData)
        $scope.userData = {};
      }
    }

    $scope.signOut = function () {
      user.signOut();
    }

    $scope.fbSignIn = function () {
      user.fbSignUp();
    }

  }
]);
