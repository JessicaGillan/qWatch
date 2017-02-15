qWatch.directive('searchResult', [
  '$rootScope', '$timeout', '$window', '$state',
  function($root, $timeout, $window, $state){

    var _toggleShareIcons = function _toggleShareIcons(scope) {
      scope.showShare = !scope.showShare;
    }

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

      scope.show = function show(e, watchable) {
        if(scope.current.id !== scope.item.id){
          e.stopPropagation();
          watchable.show().then(function(){
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
      }

      scope.showShare = false;
      scope.toggleShareIcons = function () {
        _toggleShareIcons(scope);
      };
    }

    return {
      scope: {
        item: '=',
        current: '=',
        images: '=',
        prefetched: '@'
      },
      restrict: 'E',
      link: link,
      templateUrl: 'ng/directives/search-result.html'
    }
  }
])
