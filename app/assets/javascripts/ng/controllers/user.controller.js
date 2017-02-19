qWatch.controller('UserCtrl', [
  '$scope', '$state', 'Auth', '$timeout', 'facebookService',
  function($scope, $state, Auth, $timeout, facebook) {
    "use strict";

    console.log('user ctrl')

    $scope.login = function(e) {
      e.preventDefault();

      console.log("ctrl login")
      facebook.login();
    }
    $scope.logout = function(e) {
      e.preventDefault();

      console.log("ctrl logout")
      facebook.logout();
    }


    // $scope.login = function(loginForm, loginData) {
    //   // user service
    // }

    $scope.newSignUp = function signup(data, form){
      console.log(form)
      if(form.$valid){
        // user service
      }
    }

    $scope.$on('devise:login', function(){
      console.log("devis login!")
    })

    $scope.$on('devise:new-session', function(){
      console.log("devis new session!")
    })
  }
]);
