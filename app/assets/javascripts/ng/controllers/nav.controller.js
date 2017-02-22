qWatch.controller('NavCtrl', [
  '$scope', '$state', '$rootScope', '$timeout', 'userService', 'viewedItemsService',
  function($scope, $state, $root, $timeout, user, viewedItems) {
    "use strict";

    /*
    * Object to hold signed in user data
    *
    *   id:    user ID
    *
    *   email: user Email Address
    *
    *   name:  user's Full Name
    *
    */
    $scope.userData = {};
    $scope.toggled = true;
    $scope.wrapper = angular.element("#wrapper");

    // scope function to go to the 'List' state
    $scope.goToIndex = function goToIndex(){
      // Ensure normalization by doing a full page load
      location.href = "/"
    }

    $scope.signedInUser = function signedInUser() {
      // check if user is signed in
      // save to variable fix multi call angular bug
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
      viewedItems.fetchFriends();

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
