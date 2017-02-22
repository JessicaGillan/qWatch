qWatch.factory('userService',
  ['$rootScope', '$q', '_', 'Auth', 'facebookService',
    function($root, $q, _, Auth, facebook) {
      "use strict";

      var _user = {};

      var _setUser = function _setUser(user, callback) {
        angular.copy(user, _user);
        $root.currentUser = _user;
        console.log(user)

        if (callback) callback(_user);
        
        return _user;
      }

      var _setCurrentUser = function _setCurrentUser() {
        return Auth.currentUser()
        .then(function(user) {
          return _setUser(user);
        })
        .catch(function(err) {
          console.log("no current user found")
          console.error(err);
          $q.reject("Not Logged In");
        });
      }
      _setCurrentUser();

      //----- Access Methods ------------//

      var getCurrentUser = function () {
        return _user
      }

      var signedIn = function signedIn () {
        return !(_.isEmpty(_user));
      }

      var logIn = function logIn(loginData) {
        return Auth.login(loginData)
          .then( function (user) {
            return _setUser(user);
          })
          .catch(function(e) {
            alert("Invalid Credentials:", e);
            return $q.reject("Invalid Credentials")
          });
      }

      var logOut = function logOut() {
        Auth.logout()
          .then( function (r) {
            _setUser({});
            return true;
          })
          .catch(function (e){
            console.error(e);
            return $q.reject(e);
          });
      }

      var _stringifyErrors = function _stringifyErrors(errors){
        var errStr = "";
        for(var e in errors){
          var error = errors[e]
          for(var i = 0, length = error.length; i < length; i++){
            errStr += e + " " + error[i] + "; ";
          }
        }
        return errStr;
      }

      var signUp = function signUp(data){
        return Auth.register({
          email: data.email,
          password: data.password,
          password_confirmation: data.password_confirmation,
          name: data.name
        })
        .then(function(user){
          _setCurrentUser();
          return getCurrentUser();
        })
        .catch(function(err){
          var errStr = _stringifyErrors(err.data.errors)
          alert("Registration Failed: " + errStr)
          return $q.reject(errStr);
        });
      }

      var fbSignUp = function fbSignUp() {
        var authResponse;
        return facebook.login()
                .then(function(res) {
                  if (res.status === 'connected') {
                    //  The user is logged in, retrieve personal info
                    authResponse = res.authResponse
                    return facebook.getUserInfo()
                  }

                  return $q.reject('Canceled');
                })
                .then(function (userInfo) {
                  return facebook.backendLogIn(authResponse, userInfo)
                })
                .then(function (user) {
                  _setUser(user);
                  return getCurrentUser();
                })
      }

      var _deleteAccount = function _deleteAccount(){
        var currentUser = getCurrentUser();
        if(currentUser.provider === "facebook"){
          return facebook.destroy().then(function(){
            return Auth.register({}, {method: 'DELETE'})
          })
        } else {
          return Auth.register({}, {method: 'DELETE'})
        }
      }

      var destroyAccount = function destroyAccount(){
        return _deleteAccount().then(function(){
          _setUser({});
          return true;
        })
        .catch(function(e){
          $q.reject(e);
        })
      };

      return {
        currentUser: getCurrentUser,
        signedInUser: signedIn,
        signIn: logIn,
        signUp: signUp,
        signOut: logOut,
        fbSignUp: fbSignUp,
        destroy: destroyAccount
      };
    }
  ]
);
