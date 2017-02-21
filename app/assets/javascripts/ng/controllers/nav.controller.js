qWatch.controller('NavCtrl', [
  '$scope', '$state', '$rootScope', '$timeout', 'userService', 'viewedItemsService',
  function($scope, $state, $root, $timeout, user, viewedItems) {
    "use strict";

    $scope.userData = {};
    $scope.toggled = true;
    $scope.wrapper = angular.element("#wrapper");

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
      $scope.userData = {};
    }

    $scope.toggleSideBar = function (e) {
      e.preventDefault();

      viewedItems.fetchAll();

      $scope.wrapper.toggleClass("toggled");
      $scope.toggled = !$scope.toggled;
    }

    $scope.$on('devise:login', function(){
      console.log("devise login!")
    })

    $scope.$on('devise:logout', function(){
      console.log("devise logout!")
    })

  }
]);
