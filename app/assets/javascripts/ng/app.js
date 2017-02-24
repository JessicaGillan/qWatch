// IIFE load the Facebook javascript SDK
(function(d){
  var js, ref,
      id = 'facebook-jssdk';

  // exit if sdk already exists on page
  if (d.getElementById(id)) {
    return;
  }

  // get the first scrip el in the document to insert the facebook sdk before it
  ref = d.getElementsByTagName('script')[0];

  // create empty script element to inject facebook sdk
  js = d.createElement('script');

  // set element id to facebook-jssdk
  js.id = id;

  // asyc load script
  js.async = true;

  // set src
  js.src = "//connect.facebook.net/en_US/sdk.js";

  // insert SDK before first script tag
  ref.parentNode.insertBefore(js, ref);

}(document));

var qWatch = angular
    .module('qWatch', ['ui.router', 'ui.bootstrap','restangular', 'Devise', '720kb.socialshare', 'ngMessages', 'ngtimeago', 'ngCookies'])
    .constant('_', window._)

    .config([
      'RestangularProvider',
      function(RestangularProvider) {
        // Base API Url
        RestangularProvider.setBaseUrl("/api/v1");

        // Request all routes as JSON
        RestangularProvider.setRequestSuffix('.json');

        // all ajax calls through Restangular will expect JSON
        RestangularProvider.setDefaultHttpFields({
          'content-type' : 'application/json'
        });
      }
    ])

    //----------- HTTP CONFIGURATION ---------------------//
    .config([
      "$httpProvider",
      function($httpProvider) {
        var token = angular.element('meta[name=csrf-token]')
          .attr('content');
        $httpProvider
          .defaults
          .withCredentials = true;

        $httpProvider
          .defaults
          .headers
          .common['X-CSRF-Token'] = token;
      }
    ]);

    //----------- DEVISE CONFIGURATION -------------------//
    .config([
      'AuthProvider', 'AuthInterceptProvider',
      function(AuthProvider, AuthInterceptProvider) {
        // api login url
        AuthProvider.loginPath('/api/v1/users/sign_in.json');

        // api logout url
        AuthProvider.logoutPath('/api/v1/users/sign_out.json');

        // api signup url
        AuthProvider.registerPath('/api/v1/users.json');

        // Allow Devise event listeners
        AuthInterceptProvider.interceptAuth(true);

        // Devise Model name
        AuthProvider.resourceName('user');
      }
    ])

    //----------- UI-Router CONFIGURATION -------------------//
    .config([
      '$stateProvider', '$urlRouterProvider',
      function($stateProvider, $urlRouterProvider) {
        $urlRouterProvider.otherwise('/watch');

        $stateProvider
          // Top Level Parent State
          .state('main', {
            url: "/",
            // Not Directly Navigable
            abstract: true,
            // Top Lvl Views
            views: {
              // Global Search Bar
              'search': {
                templateUrl: 'ng/views/search.html',
                controller: 'SearchCtrl'
              },
              // Fixed Navbar
              'nav': {
                templateUrl: 'ng/views/nav.html',
                controller: 'NavCtrl'
              },
              // User Modal
              'signUp': {
                template: '<sign-up-modal></sign-up-modal><deregister-modal></deregister-modal>',
              },

              // Side Bar of Viewed items
              'recentlyViewed': {
                template: '<side-bar></sidebar>',
              },

              // Main Content

              '': {
                template: '<ui-view/>'
              }
            }
          })
          // Show Individual Item State
          // Used when coming from external URL
          .state('show', {
            // Uses TMDB info to grab movie (qwatch.me/watch/movie/18445)
            url: 'watch/:type/:id',
            parent: 'main',
            templateUrl: 'ng/views/list/show.html',
            controller: 'ListShowCtrl'
          })
          // Index of All Movies, Main State
          .state('list', {
            parent: 'main',
            url: 'watch',
            // Optional param for when user types in global search bar from show page
            params: {
              searchSet: null
            },
            templateUrl: 'ng/views/list/index.html',
            controller: 'ListIndexCtrl'
          })
          // Share page for use with Chrome Extension and Voice API
          .state('share', {
            // qwatch.me/share?title=suicide%20squad
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

        // FACEBOOK Configuration params
        // Executed when the SDK is loaded
        $window.fbAsyncInit = function() {
          facebook.init($window.FB, $cookies.get("fb_app_id"));
        };

      }]);
