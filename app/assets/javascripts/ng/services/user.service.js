qWatch.factory('userService',
  ['$rootScope', 'Restangular', 'Auth',
    function($root, Restangular, Auth) {
      "use strict";

      var _user = {};

      var _setUser = function _setUser(user) {
        angular.copy(user, _user);
        $root.currentUser = _user;
      }

      Auth.currentUser()
      .then(function(user) {
        _setUser(user);
      })
      .catch(function(err) {
        console.log("no current user found")
        console.error(err);
      });

      //----- Access Methods ------------//

      var getCurrentUser = function () {
        return _user
      }

      var signedIn = function signedIn () {
        return !!Object.keys(_user).length
      }

      var logIn = function logIn(loginData) {
        Auth.login(loginData)
          .then( function (user) {
            _setUser(user);
          })
          .catch( function (e) { alert("Invalid Credentials:", e) });
      }

      var logOut = function logOut() {
        Auth.logout()
          .then( function (r) {
            _setUser({});
          })
          .catch( function (e) { console.error(e) });
      }

      var signUp = function signUp(data){
        console.log(data)

        Auth.register({
          email: data.email,
          password: data.password,
          password_confirmation: data.password_confirmation
        })
        .then(function(user){
          console.log("created user", user)
        })
        .catch(function(err){
          var errStr = "";
          for(var e in err.data.errors){
            var error = err.data.errors[e]
            for(var i = 0; i < error.length; i++){
              errStr += e + " " + error[i] + "; "
            }
          }
          alert("Registration Failed: " + errStr)
        });
      }

      return {
        currentUser: getCurrentUser,
        signedInUser: signedIn,
        signIn: logIn,
        signUp: signUp,
        signOut: logOut
      };
    }
  ]
);
