qWatch.directive('deregisterModal',
  [ 'userService',
    function(user) {
      "use strict";

      return {
        restrict: 'E',
        scope: {},
        templateUrl: 'ng/directives/deregister-modal.html',
        link: function(scope, element) {

          scope.submit = function submit() {
            if(!scope.disableButtons){
              scope.disableButtons = true
              user.destroy().then(function(){
                dismissModal();
                scope.disableButtons = false;
              })
              .catch(function(e){
                alert("Error Deleting account")
              })
            }
          };


          var dismissModal = function () {
            angular.element(element).children('#deleteAccountModal').modal('hide');
          }
        }
      };
}]);
