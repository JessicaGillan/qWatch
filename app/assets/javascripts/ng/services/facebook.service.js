qWatch.factory('facebookService', [
  '$q', '$rootScope',
  function ($q, $rootScope) {
    var _user = {};

    var watchLoginChange = function() {
      FB.Event.subscribe('auth.authResponseChange', function(res) {
        console.log("login change", res)
        if (res.status === 'connected') {

          //  The user is already logged in, retrieve personal info
          _getUserInfo();

          /*
           create a session for the current user. - if they signed up with qWatch
           use the data inside the res.authResponse object.
          */
        }
        else {
          /*
           The user is not logged to the app, or into Facebook:
           destroy the session on the server.
          */
        }
      });
    }

    var _getUserInfo = function _getUserInfo() {
      var deferred = $q.defer();

      FB.api('/me', { fields: 'id,name,email' },function(response) {
        if (!response || response.error) {
          deferred.reject('Error occured');
        } else {
          console.log("got user info", response)
          angular.copy(response, _user)

          $rootScope.$apply(function() { $rootScope.user = _user; });

          deferred.resolve(response);
        }
      });

      return deferred.promise;
    }

    var logout = function login() {
      FB.logout(function(response) {
        console.log("logged out", response)
        angular.copy({}, _user)
      });
    }

    var login = function login() {
      FB.login(function(response) {
        console.log("login response", response);

        // if (response.status === 'connected') {
        //   // Logged into your app and Facebook.
        // } else if (response.status === 'not_authorized') {
        //   // The person is logged into Facebook, but not your app.
        // } else {
        //   // The person is not logged into Facebook, so we're not sure if
        //   // they are logged into this app or not.
        // }

        if (response.authResponse) {
          console.log('Connected! Hitting OmniAuth callback (GET /auth/facebook/callback)...');
          _getUserInfo().then( function (response) {
            console.log("user info response", response)
          })
          // since we have cookies enabled, this request will allow omniauth to parse
          // out the auth code from the signed request in the fbsr_XXX cookie
          // $.getJSON('/api/v1/users/auth/facebook/callback',  { code: response.authResponse.signedRequest },
          // $.getJSON('/api/v1/users/auth/facebook/callback',
          // { auth: response.authResponse },
          // function(json) {
          //   console.log('Connected! Callback complete.');
          //   console.log("results", JSON.stringify(json));
          // });
        }
      }, {scope: 'email', info_fields: 'id,name,email'});
    }

    return {
      watchAuthenticationStatusChange: watchLoginChange,
      logout: logout,
      login: login
    }

  }
]);
