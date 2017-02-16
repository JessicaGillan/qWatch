qWatch.directive('centerFlash', function () {

  function fade(element) {
    element.classList.add('flash-fade');
  }

  return {
    restrict: 'E',
    scope: {
      msgType: '=',
      msgText: '='
    },
    template: '<div class="flash {{ msgType }}" id="flash-content">{{ msgText }}</div>',
    link: function(scope, element, attrs) {
      element.addClass(scope.msgType);

      var content = document.getElementById('flash-content');

      element[0].addEventListener('flashSet', function() {
        element[0].classList.add('flash-show');

        setTimeout(function(){ fade(content); }, 1000);
      });
    },
  };
});
