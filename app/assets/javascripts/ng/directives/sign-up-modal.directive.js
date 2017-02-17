qWatch.directive('signUpModal', function() {
  return {
    restrict: 'E',
    scope: {
      signUp: '=signUp',
    },
    templateUrl: 'ng/directives/sign-up-modal.html',
    link: function(scope, element, attrs) {
      element.on('show.bs.modal', function (event) {
        console.log("show modal event ")
        // scope.card = $(event.relatedTarget).data('card'); // Extract info from data-* attributes
        //
        // var $modal = $(this);
        //
        // angular.element($modal).injector().invoke(function($compile) {
        //   var $scope = angular.element($modal).scope();
        //   $scope.$apply();
        // });
      })
    }
  };
});
