qWatch.directive('searchResult', [
  '$rootScope', '$timeout', '$window', '$state', 'viewedItemsService',
  function($root, $timeout, $window, $state, viewed){
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
        $state.go('show', {id: scope.item.tmdb_id, type:scope.item.tmdb_type}, {notify: false})
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

      scope.view = function view(url){
        viewed.create(scope.item.tmdb_id, scope.item.tmdb_type)
        $timeout(function(){
          $window.location.href = url;
        })
      }

      scope.hide = function hide() {
        $root.$emit("hideItem");
        if(scope.offIndex === 'true') return $state.go('list', {}, {inherit: false})
        _slideDown(scope, el);
      }

      if(scope.prefetched === 'true'){
        _slideUp(scope, el);
      } else {
        if(scope.tracker) scope.tracker[scope.item.id] = scope.show
      }
    }

    return {
      scope: {
        item: '=',
        current: '=',
        images: '=',
        prefetched: '@',
        offIndex: '@',
        tracker: '=',
      },
      restrict: 'E',
      link: link,
      templateUrl: 'ng/directives/search-result.html'
    }
  }
])
