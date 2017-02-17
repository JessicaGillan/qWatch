qWatch.directive('signUpModal',
  [ 'userService',
    function(user) {
      "use strict";

      var submit = function submit(form, formData) {
        if (form.$valid) {
          user.signUp(formData);
          return true
        }

        return false
      }

      var passwordMatch = function passwordMatch(data, form){
        if(data.password !== data.password_confirmation){
          form.password_confirmation.$setValidity('pwdmatch', false)
        } else {
          form.password_confirmation.$setValidity('pwdmatch', true)
        }
      }

      return {
        restrict: 'E',
        scope: {},
        templateUrl: 'ng/directives/sign-up-modal.html',
        link: function(scope, element, attrs) {
          scope.userData = {};

          scope.submit = function (form, formData) {
            if (submit(form, formData)){
              angular.element(element).children('#signUpModal').modal('hide');
            }
          };

          scope.passwordMatch = passwordMatch;
        }
      };
}]);
