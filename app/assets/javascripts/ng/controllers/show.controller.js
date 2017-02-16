qWatch.controller('ShowCtrl',[
  '$scope',
  function($scope){
    "use strict";

    $scope.$on('showItem', function(event, el){
      var div = angular.element(el);
      var parent = angular.element("#main-show");
      var rect = div.get(0).getBoundingClientRect();
      parent.css({left: rect.left, top: rect.top})
      $scope.expanded = true;
    });

    $scope.$on('hideItem', function(event, el){
      var parent = angular.element("#main-show");
      $scope.expanded = false;
      div.css({left: null, top: null, position: null})
    });
  }
])
