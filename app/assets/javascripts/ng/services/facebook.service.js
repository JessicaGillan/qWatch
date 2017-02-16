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
           create a session for the current user.
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

      FB.api('/me', function(response) {
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

    var logout = function() {
      FB.logout(function(response) {
        console.log("logged out", response)
        angular.copy({}, _user)
      });
    }

    return {
      watchAuthenticationStatusChange: watchLoginChange,
      logout: logout
    }

  }
]);
