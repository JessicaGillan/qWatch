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
      scope.friendsViewed = viewedItems.getFriends();

      scope.showing = 'mine';

      scope.mine = angular.element('#mine');
      scope.friends = angular.element('#friends');

      scope.tabSelect = function (e) {
        e.preventDefault();

        if (e.target.text === scope.mine.text()) {
          scope.showing = 'mine';
          scope.mine.addClass('selected');
          scope.friends.removeClass('selected');
        } else {
          scope.showing = 'friends';
          scope.friends.addClass('selected');
          scope.mine.removeClass('selected');
        }
      }

    }
  };
}]);
