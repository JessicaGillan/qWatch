qWatch.directive('sideBar', [
'viewedItemsService',
  function (viewedItems) {
  "use strict";


  return {
    restrict: 'E',
    scope: {
    },
    templateUrl: 'ng/directives/side-bar.html',
    link: function(scope, element, attrs) {
      scope.viewedItems = viewedItems.getAll();
    }
  };
}]);
