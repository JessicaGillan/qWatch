qWatch.directive('searchResult', [
  '$rootScope', '$timeout', '$window',
  function($root, $timeout, $window){

    var _slideUp = function _slideUp(el){
      var rect = el.get(0).getBoundingClientRect();
      el.css({position: "fixed", left: rect.left, top: rect.top, width: rect.width})
      $timeout(function(){
        el.addClass("expanded");
      })
    }

    var _slideDown = function _slideDown(scope, el){
      el.removeClass("expanded");
      $timeout(function(){
        scope.current.id = void(0);
        scope.current.div = void(0)
        el.css({position: "", left: "", top: "", width: ""})
      }, 500)
    }

    var link = function link(scope, el){
      scope.show = function show(e, watchable) {
        if(scope.current.id !== scope.item.id){
          e.stopPropagation();
          watchable.show().then(function(){
            scope.current.div = el;
            _slideUp(el);
            scope.current.id = scope.item.id;
            $root.$emit("showItem")
          })
        }
      }

      scope.hide = function hide() {
        $root.$emit("hideItem");
        _slideDown(scope, el);
      }
    }

    return {
      scope: {
        item: '=',
        current: '='
      },
      restrict: 'E',
      link: link,
      templateUrl: 'ng/directives/search-result.html'
    }
  }
])
