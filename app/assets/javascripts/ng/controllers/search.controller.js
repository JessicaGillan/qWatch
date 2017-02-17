qWatch.controller('SearchCtrl',[
  '$scope', '$rootScope', '$timeout',
  function($scope, $root, $timeout){
    "use strict";

    /*
    * SCOPE VARS:
    * _handler:       <Promise>   placeholder for $timeout in searchFor;
    *                             Important for not making too many calls to backend
    *
    * searchWrapper:  <Element>   outer div that houses header and scroll input
    *
    * navBar:         <Element>   top of page navigation bar
    *
    * searchEl:       <Element>   the search form
    *
    * sBarRect:       <Object>    searchEl boundingClientRect
    *
    * found:         <boolean>   track whether searchWrapper, navBar, and searchEl have already been found in the dom
    *
    * showing:        <boolean>   track whether a full search result is being shown
    *
    * initial:        <boolean>   boolean to not call searchFor on initialization
    */
    var _handler, searchWrapper, navBar, searchEl, found, sBarRect,
        showing = false,
        initial = true;

    // ngModel for search form
    $scope.search = {term: ""};

    // get searchWrapper from dom if it hasn't been; avoid multiple lookups
    var _getSearchWrapper = function _getSearchWrapper(){
      return searchWrapper = searchWrapper || angular.element('.title-search');
    }

    // get navBar from dom if it hasn't been; avoid multiple lookups
    var _getNavBar = function _getSearchWrapper(){
      return navBar = navBar || angular.element('#main-nav');
    }

    // get searchEl from dom if it hasn't been; avoid multiple lookups
    var _getSearchEl = function _getSearchEl(){
      return searchEl = searchEl || angular.element('#search-panel');
    }

    // grab all three dom elements in one call if this function has not been called before
    var _getPageElements = function _getPageElements(){
      if(!found){
        _getSearchWrapper();
        _getNavBar();
        _getSearchEl();
      }
    }

    // emit the appropriate search event given a term
    // keep emissions on $root scope for better performance. be on alert for memory leaks
    var searchFor = function searchFor(term){
      // if not initial page load
      if(!initial){

        // if new keys have been pressed before timeout debounce
        if(_handler) $timeout.cancel(_handler);

        // run event emissions in timeout so they can be canceled on consecutive key presses
        _handler = $timeout(function(){

          // if search has been emptied emit search cleared
          if(term.length === 0){
            $root.$emit('searchClear')

          // else if at least 3 characters have been typed run a search
          } else if(term.length > 2) {
            $root.$emit('searchSet', term)
          }
        }, 300)
      }
      // once this function has been called at least once we can get this party rockin'
      initial = false;
    };

    // put searchEl back in it's origininal position
    var _resetSearchEl = function _resetSearchEl(){
      $scope.showFiller = false;
      searchEl.removeClass("stick-top")
      searchEl.css({position: "", top: ""})
    }

    // check if searchEl should be stuck to top of page
    var _checkSearchElPosition = function _checkSearchElPosition(){
      if(!found) _getPageElements();
      var sWrapRect = searchWrapper.get(0).getBoundingClientRect();
      var navRect = navBar.get(0).getBoundingClientRect();
      sBarRect = sBarRect || searchEl.get(0).getBoundingClientRect();
      return !showing && sWrapRect.top + sWrapRect.height <= (navRect.height + sBarRect.height)
    }

    // set searchEl to stick to top of page
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

    // move searchEl to 'full result' position
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

    // full result has been collapsed, move searchEl back to where it was
    var _moveFromShow = function _moveToShow(){
      showing = false;
      _getSearchEl();
      searchEl.removeClass('showing');
      $timeout(function(){
        searchEl.css({position: "", top: ""})
      },500)
      if(_checkSearchElPosition()) _setSearchElFixed();
    }

    // watch for changes in search form ngModel, run searchFor()
    $scope.$watch('search.term', searchFor)

    // run _moveFromShow on new search query
    $root.$on('searchSet', _moveFromShow);

    // run _moveToShow when a full search result is selected to be shown
    $root.$on('showItem', _moveToShow);

    // run _moveFromShow on search result collapse
    $root.$on('hideItem', _moveFromShow);

    // scroll listener to stick searchEl to top of page
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
