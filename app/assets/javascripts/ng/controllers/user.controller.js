qWatch.controller('UserCtrl', [
  '$scope', '$state', 'Auth', '$timeout',
  function($scope, $state, Auth, $timeout) {
    // var test = function(){
    //   Auth.currentUser().then((user) => {
    //
    //     $state.go('boards.index')
    //
    //   }).catch(err => console.log(err))
    // }
    // test()
    //
    // $scope.$on('devise:login', function(){
    //   $state.go('boards.index')
    // })
    //
    // $scope.$on('devise:new-session', function(){
    //   $state.go('boards.index')
    // })
    //
    //
    // $scope.login = function(loginForm, loginData) {
    //   Auth.login(loginData)
    //     .then(r => $state.go('boards.index'))
    //     .catch(e => { alert("Invalid Credentials:", e) })
    // }
    //
    // $scope.newSignUp = function signup(data, form){
    //   console.log(form)
    //   if(form.$valid){
    //     Auth.register({
    //       email: data.email,
    //       password: data.password,
    //       password_confirmation: data.password_confirmation
    //     }).then(function(user){
    //       $state.go('boards.index')
    //     })
    //     .catch(function(err){
    //       var errStr = "";
    //       for(var e in err.data.errors){
    //         var error = err.data.errors[e]
    //         for(var i = 0; i < error.length; i++){
    //           errStr += e + " " + error[i] + "; "
    //         }
    //       }
    //       alert("Registration Failed: " + errStr)
    //     })
    //   }
    // }
    //
    // $scope.passwordMatch = function passwordMatch(data, form){
    //   if(data.password !== data.password_confirmation){
    //     form.password_confirmation.$setValidity('pwdmatch', false)
    //   } else {
    //     form.password_confirmation.$setValidity('pwdmatch', true)
    //   }
    // }

  }
]);
