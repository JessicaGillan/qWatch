qWatch.directive('searchResult', [
  '$rootScope', '$timeout', '$window', '$state',
  function($root, $timeout, $window, $state){
    "use strict";

    var _setPosition = function _setPosition(el){
      var rect = el.get(0).getBoundingClientRect();
      el.css({transitionDuration: "0s", left: rect.left, top: rect.top, width: rect.width, position: "fixed", })
      $timeout(function(){
        el.css({transitionDuration: ""})
      },1)
    }

    var _slideUp = function _slideUp(scope, el){
      scope.current.div = el;
      _setPosition(el);

      $timeout(function(){
        $state.go('show', {id: scope.item.id}, {notify: false})
        scope.current.id = scope.item.id;
        el.addClass("expanded");
        $root.$emit("showItem");
      })
    }

    var _slideDown = function _slideDown(scope, el){
      el.removeClass("expanded");

      $timeout(function(){
        $state.go('list', {}, {notify: false});
        scope.current.id = void(0);
        scope.current.div = void(0)
        el.css({position: "", left: "", top: "", width: ""})
      }, 500)
    }

    var link = function link(scope, el){
      $timeout(function(){
        scope.svg = "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' version='1.1' height='100%' width='100%'><text x='0' y='15' fill='white' font-size='50'>" + scope.item.title + "</text></svg>";
      })

      scope.show = function show(e) {
        if(scope.current.id !== scope.item.id){
          if(e) e.stopPropagation();
          scope.item.show().then(function(){
            _slideUp(scope, el);
          })
        }
      }

      scope.hide = function hide() {
        $root.$emit("hideItem");
        _slideDown(scope, el);
      }

      if(scope.prefetched){
        _slideUp(scope, el);
      } else {
        scope.tracker[scope.item.id] = scope.show
      }
    }

    return {
      scope: {
        item: '=',
        current: '=',
        images: '=',
        prefetched: '@',
        tracker: '=',
      },
      restrict: 'E',
      link: link,
      templateUrl: 'ng/directives/search-result.html'
    }
  }
])
