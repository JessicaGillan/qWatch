qWatch.directive('shareButtons', [
  'viewedItemsService',
  function(viewed) {
    "use strict";

    return {
      restrict: 'E',
      scope: {
        title: '@',
        shareUrl: '@',
        shareImg: '@',
        watchable: '='
      },
      templateUrl: 'ng/directives/share-buttons.html',
      link: function(scope, element, attrs) {
        // TODO: change || setting to location.href
        // FB will not work with localhost urls
        scope.shareUrl = scope.shareUrl || "https://qwatch.me/"

        scope.view = function view(){
          viewed.create(scope.watchable.tmdb_id, scope.watchable.tmdb_type, 'shared')
        }

      }
    };
  }
]);
