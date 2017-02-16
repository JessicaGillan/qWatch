qWatch.directive('shareButtons', function() {
  "use strict";

  return {
    restrict: 'E',
    scope: {
      title: '@',
      shareUrl: '@',
      shareImg: '@'
    },
    templateUrl: 'ng/directives/share-buttons.html',
    link: function(scope, element, attrs) {
      // TODO: change || setting to location.href
      // FB will not owrk with localhost urls
      scope.shareUrl = scope.shareUrl || "https://qwatch.me/"
    }
  };
});
