var qWatch = angular
    .module('qWatch', ['ui.router', 'ui.bootstrap','restangular', 'Devise'])
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
      'AuthProvider',
      function(AuthProvider) {
        // AuthProvider.loginPath('/api/v1/users/sign_in.json');
        // AuthProvider.logoutPath('/api/v1/users/sign_out.json');
        // AuthProvider.registerPath('/api/v1/users/sign_up.json');
        // AuthInterceptProvider.interceptAuth(true);

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
              'show': {
                template: '<ui-view="show-item"></ui-view>',
                controller: 'ShowCtrl'
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
          .state('list', {
            parent: 'main',
            url: 'watch',
            templateUrl: 'ng/views/list/index.html',
            controller: 'ListIndexCtrl'
          })
          .state('list.show', {
            url: '/:id',
            views: {
              'show-item@main': {
                templateUrl: 'ng/views/list/show.html',
                controller: 'ListShowCtrl'
              }
            }
          })

      }
    ]);
