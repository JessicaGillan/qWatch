qWatch.controller('ListShowCtrl',[
  '$scope', '$state', '$stateParams', '$rootScope', 'watchableService', 'tmdbConfigService',
  function($scope, $state, $stateParams, $root, watchableService, tmdbConfig){
    "use strict";

    $root.showPage = true;

    $scope.currentItem = {};
    tmdbConfig().then(function(sizes){
      $scope.imageSizes = sizes;
    });
    watchableService.show($stateParams.type, $stateParams.id)
      .then( function (watchable) {
        $scope.watchable = watchable;
        $scope.currentItem.id = watchable.id
      });

    var _onHandler = $root.$on('searchSet', function(event, term){
      _onHandler();
      $state.go('list', {searchSet: term}, {inherit: false})
    })
  }
])
