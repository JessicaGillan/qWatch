var qWatch = angular
    .module('qWatch', ['ui.router', 'ui.bootstrap','restangular', 'Devise', '720kb.socialshare', 'ngMessages', 'ngCookies'])
    .constant('_', window._)
    .config([
      'RestangularProvider',
      function(RestangularProvider) {
        RestangularProvider.setBaseUrl("/api/v1");
        RestangularProvider.setRequestSuffix('.json');
        RestangularProvider.setDefaultHttpFields({
          'content-type' : 'application/json'
        });
      }
    ])
    .config([
      'AuthProvider', 'AuthInterceptProvider',
      function(AuthProvider, AuthInterceptProvider) {
        AuthProvider.loginPath('/api/v1/users/sign_in.json');
        AuthProvider.logoutPath('/api/v1/users/sign_out.json');
        AuthProvider.registerPath('/api/v1/users.json');
        AuthInterceptProvider.interceptAuth(true);

        AuthProvider.resourceName('user');
      }
    ])
    .config([
      '$stateProvider', '$urlRouterProvider',
      function($stateProvider, $urlRouterProvider) {
        $urlRouterProvider.otherwise('/watch');

        $stateProvider
          .state('main', {
            url: "/",
            abstract: true,
            views: {
              'search': {
                templateUrl: 'ng/views/search.html',
                controller: 'SearchCtrl'
              },
              'nav': {
                templateUrl: 'ng/views/nav.html',
                controller: 'NavCtrl'
              },
              'signUp': {
                template: '<sign-up-modal></sign-up-modal>',
                controller: 'SignUpCtrl'
              },
              '': {
                template: '<ui-view/>'
              }
            }
          })
          .state('user', {
            parent: 'main',
            url: 'user',
            templateUrl: 'ng/views/user.html',
            controller: 'UserCtrl'
          })
          .state('show', {
            url: 'watch/:type/:id',
            parent: 'main',
            templateUrl: 'ng/views/list/show.html',
            controller: 'ListShowCtrl'
          })
          .state('list', {
            parent: 'main',
            url: 'watch',
            params: {
              searchSet: null
            },
            templateUrl: 'ng/views/list/index.html',
            controller: 'ListIndexCtrl'
          })
          .state('share', {
            url: 'share?title',
            parent: 'main',
            templateUrl: 'ng/views/share.html',
            controller: 'ShareCtrl'
          })


      }
    ])

    //----------- LOAD AND INIT FACEBOOK JAVASCRIPT SDK -------------------//

    .run(['$rootScope', '$window', '$cookies', 'facebookService',
      function($rootScope, $window, $cookies, facebook) {
        $rootScope.currentUser = {};

        $window.fbAsyncInit = function() {
          // Executed when the SDK is loaded
          // console.log("fb_app_id:", $cookies.get("fb_app_id") || 0)
          FB.init({
            // TODO: change to cookie set in rails angular controller
            appId: $cookies.get("fb_app_id") || 0,
            status: true, // Check auth status at the start of the app
            cookie: true, // Enable cookis so server can access the session
            version: 'v2.6'
          });

          facebook.watchAuthenticationStatusChange();
        };

        (function(d){
          // load the Facebook javascript SDK
          var js,
          id = 'facebook-jssdk',
          ref = d.getElementsByTagName('script')[0];

          if (d.getElementById(id)) {
            return;
          }

          js = d.createElement('script');
          js.id = id;
          js.async = true;
          js.src = "//connect.facebook.net/en_US/sdk.js";

          ref.parentNode.insertBefore(js, ref);

        }(document));

      }]);
