qWatch.factory('facebookService', [
  '$q', '$rootScope', 'Auth',
  function ($q, $rootScope, Auth) {
    var watchLoginChange = function() {
      FB.Event.subscribe('auth.authResponseChange', function(res) {
        console.log("FB login change")

        if (res.status === 'connected') {
          // TODO: update logic flow
          // This will sign in user, but not make 'devise:login' event,
          // and not run digest loop, so user looks signed out until refresh
          // Also - what happens if this automatically runs for user not
          // signed up with qWatch but signed in to FB?

          //  The user is already logged in, retrieve personal info
          // getUserInfo()
          // .then( function (userInfo) {
            /*
             create a session for the current user. - if they signed up with qWatch
             use the data inside the res.authResponse object.
            */

            // backendLogIn(res.authResponse, userInfo)
          // })

        }
        else {
          /*
           The user is not logged to the app, or into Facebook:
           destroy the session on the server.
          */
          _backendLogOut();
        }
      });
    };


    var logout = function login() {
      FB.logout(function(response) {
        console.log("FB logged out")
      });
    };

    var login = function login() {
      return _getLoginStatus()
              .then(function (response) {
                if (response.status == 'connected') {
                  return response
                } else {
                  return _fbLogin()
                }
              })
    };

    var backendLogIn = function backendLogIn(auth, info) {
      auth = {
        provider: "facebook",
        uid: auth.userID,
        info: {
          email: info.email,
          name: info.name,
          friends: info.friends
        }
      }

      /*
       since we have cookies enabled, this request will allow omniauth to parse
       out the auth code from the signed request in the fbsr_XXX cookie
      */

      return $.getJSON('/api/v1/users/auth/facebook/callback',
              { auth: auth },
              function(json) {
                return json
              });
    };

    var getUserInfo = function getUserInfo() {
      var deferred = $q.defer();

      FB.api('/me', { fields: 'id,name,email,friends' },function(response) {
        if (!response || response.error) {
          deferred.reject('Error occured: ' + response.error.message);
        } else {
          deferred.resolve(response);
        }
      });

      return deferred.promise;
    };

    var _backendLogOut = function _backendLogOut() {
      Auth.logout();
    }

    var _getLoginStatus = function _getLoginStatus() {
      var deferred = $q.defer();

      FB.getLoginStatus(function(response) {
        if (!response || response.error) {
          deferred.reject('Error occured: ' + response.error.message);
        } else {
          deferred.resolve(response);
        }
      });

      return deferred.promise;
    };

    var _fbLogin = function _fbLogin() {
      var deferred = $q.defer();

      FB.login(function(response) {
        if (!response || response.error) {
          deferred.reject('Error occured: ' + response.error.message);
        } else {
          deferred.resolve(response);
        }
      }, {scope: 'email, user_friends', info_fields: 'id,name,email,user_friends'});

      return deferred.promise;
    };

    return {
      watchAuthenticationStatusChange: watchLoginChange,
      logout: logout,
      login: login,
      getUserInfo: getUserInfo,
      backendLogIn: backendLogIn
    }

  }
]);
