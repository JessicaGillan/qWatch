qWatch.controller('SearchCtrl',[
  '$scope', '$rootScope', '$timeout',
  function($scope, $root, $timeout){
    console.log('init search')
    var _handler, searchWrapper, navBar, searchEl, gotten,
        searchElFiller = angular.element('#search-panel-filler'),
        sBarRect;
        showing = false,
        initial = true;

    $scope.search = {term: ""};

    var _getSearchWrapper = function _getSearchWrapper(){
      return searchWrapper = searchWrapper || angular.element('.title-search');
    }
    var _getNavBar = function _getSearchWrapper(){
      return navBar = navBar || angular.element('#main-nav');
    }
    var _getSearchEl = function _getSearchEl(){
      searchEl = searchEl || angular.element('#search-panel');
      return searchEl;
    }

    var _getPageElements = function _getPageElements(){
      if(!gotten){
        _getSearchWrapper();
        _getNavBar();
        _getSearchEl();
      }
    }

    var searchFor = function searchFor(term){
      if(!initial){
        if(_handler) $timeout.cancel(_handler);

        _handler = $timeout(function(){
          if(term.length === 0){
            $root.$emit('searchClear')
          } else if(term.length > 2) {
            $root.$emit('searchSet', term)
          }
        }, 300)
      }
      initial = false;
    };

    var _resetSearchEl = function _resetSearchEl(){
      $scope.showFiller = false;
      searchEl.removeClass("stick-top")
      searchEl.css({position: "", top: ""})
    }

    var _checkSearchElPosition = function _checkSearchElPosition(){
      if(!gotten) _getPageElements();
      var sWrapRect = searchWrapper.get(0).getBoundingClientRect();
      var navRect = navBar.get(0).getBoundingClientRect();
      sBarRect = sBarRect || searchEl.get(0).getBoundingClientRect();
      return !showing && sWrapRect.top + sWrapRect.height <= (navRect.height + sBarRect.height)
    }

    var _setSearchElFixed = function _setSearchElFixed(){
      if(!$scope.showFiller){
        _getSearchEl();
        searchEl.css({transitionDuration: "0s"});
        searchEl.addClass('stick-top');
        $timeout(function(){
          searchEl.css({transitionDuration: ""});
        })
        $scope.showFiller = true;
      }
    }

    // var _slideUp = function _slideUp(){
    //   _slideDown();
    //   _resetSearchEl();
    //   angular.element('#header-wrapper').css({"max-height": 0, padding: 0});
    // }

    var _moveToShow = function _moveToShow(){
      showing = true;

      _getSearchEl();
      var srect = searchEl.get(0).getBoundingClientRect();
      searchEl.css({transitionDuration: "0s", position: "fixed", top: srect.top})

      $timeout(function(){
        searchEl.css({transitionDuration: ""})
        searchEl.addClass('showing')
      }, 10)
    }

    var _moveFromShow = function _moveToShow(){
      showing = false;
      _getSearchEl();
      searchEl.removeClass('showing');
      $timeout(function(){
        searchEl.css({position: "", top: ""})
      },500)
      if(_checkSearchElPosition()) _setSearchElFixed();
    }

    // var _slideDown = function _slideDown(){
    //   _moveFromShow();
    //   angular.element('#header-wrapper').css({"max-height": "", padding: ""});
    //   _getSearchWrapper();
    //   searchWrapper.css({position: "", left: "", top: "", width: ""})
    //   if(_checkSearchElPosition()) _setSearchElFixed();
    // }

    $scope.$watch('search.term', searchFor)

    $root.$on('searchSet', _moveFromShow);
    $root.$on('showItem', _moveToShow);

    // $root.$on('searchClear', _moveFromShow);
    $root.$on('hideItem', _moveFromShow);

    angular.element(document).on('scroll', function (e) {
      if(_checkSearchElPosition()){
        _setSearchElFixed();
      }
      else {
        if(!showing) _resetSearchEl();
      }
    });
  }
])
