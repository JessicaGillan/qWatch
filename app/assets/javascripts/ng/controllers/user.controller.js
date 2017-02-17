qWatch.controller('UserCtrl', [
  '$scope', '$state', 'Auth', '$timeout',
  function($scope, $state, Auth, $timeout) {
    "use strict";



    $scope.login = function(loginForm, loginData) {
      // user service
    }

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
