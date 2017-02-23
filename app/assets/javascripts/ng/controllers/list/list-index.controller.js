qWatch.controller('ListIndexCtrl',[
  '$scope', '$rootScope', '$timeout', '$window', '$state', '$stateParams', 'watchableService', "tmdbConfigService",
  function($scope, $root, $timeout, $window, $state, $stateParams, watchable, tmdbConfig){
    "use strict";

    /*
    * SCOPE VARS:
    * el:         the list item wrapper that contains search results;
    *             Important for scroll efects (calculating where in page the list starts)
    *
    * scroll:     A scroll-y position holder for when a search result is being shown in full;
    *             Important for scroll efects (animating result back to original position will still be in correct location)
    *
    * angWindow:  A place holder from the entire document window. Don't want to have to grab more than once;
    *
    * _rowHeight: The height (in px) of a single row of search results;
    *             Important for scroll efects calculations
    *
    * _searchDebounce:  placeholder for $timeout in _setSearch.
    *                   used to cancel a DB call on pre existing searches in case of new search before returned results;
    *
    * _initialLoaded:   placeholder for initial load of full index.
    *                   used to make sure search from show page is shown if result is returned before index;
    *
    * _handlers:        object to hold all listener handlers for destruction on navigation
    *
    */
    var el = angular.element('#watchable-search'),
        scroll = 0,
        angWindow = angular.element($window),
        _rowHeight,
        _searchDebounce,
        _initialLoaded,
        _handlers = {root: [], element: []};

    // NOT currently on SHOW page
    $root.showPage = false;

    // object to hold 'show()' functions for search-result directives
    $scope.searchResultTracker = {};

    // The current Item being shown. will contain 'id' and 'div'.
    // Always set 'id' and 'div' to be void when item not shown.
    $scope.currentItem = {};

    /*
    * OFFSET:
    * new:      the new scroll position;
    *           set by scroll event listener.
    *
    * last:     the previous scroll position;
    *           set by _debounce. used to calculate scroll direction
    *
    * begin:    beggining idx of the ng-repeat;
    *           set by _debounce. used to calculate when to load next page of results, and for limitTo offset in ng-repeat
    *
    * firstEl:  top position of result list, important for calculating scroll position relative to list;
    *
    */
    $scope.offset = {
      new: 0,
      last: 0,
      begin: 0,
      firstEl: el.offset().top
    }

    // Reset $scope.offset to initial values and scroll to top of page
    var _resetOffset = function _resetOffset(){
      angular.copy({
        new: 0,
        last: 0,
        begin: 0,
        firstEl: el.offset().top
      }, $scope.offset)
      angWindow.scrollTop(0);
    }

    // event listener wrapper to also setup deregistration
    var _setListener = function _setListener(el, ev, f){
      el.on(ev, f);
      _handlers.element.push({el: el, ev: ev, f: f})
    }

    // on resize (e.g. phone rotated or page zoomed) recalculate row height for debounce
    var _onResize = function _onResize(){
      $timeout(function(){
        _rowHeight = angular.element('.search-result-wrapper').outerHeight(true);
      })
    }

    // calculate how many rows down you are from top of page
    var _calcRows = function _calcRows(scroll){
      return Math.floor(($scope.offset.new/_rowHeight));
    }

    // function to not have too many scroll events; don't want to overload browser
    // if user scrolls again before timer ends, cancel last event
    var delayedExec = function(after, fn) {
      var timer;
      return function() {
        timer && $timeout.cancel(timer);
        timer = $timeout(fn, after);
      };
    };

    // check if you are far enough down the page to merit a list shift for new items
    var _checkScrollDown = function _checkScrollDown(){
      return _calcRows() >= 15;
    }

    // shift result list by 5 rows
    var _scrollDown = function _scrollUp(bypass) {
      // if you are 15+ rows down, or the row check is by passed
      if(bypass || _checkScrollDown()){

        // scroll window up by 5 rows
        angWindow.scrollTop(angWindow.scrollTop() - (5 * _rowHeight));

        // shift limitTo offset by 5 rows worth of results
        $scope.offset.begin += 15;

        //  if you are less than 5 rows from the end of the current page get next page of index
        //  TODO: Add check for if currently browsing search results instead of index list
        if(Math.floor(($scope.list.length - $scope.offset.begin)/3) - _calcRows() < 5){
          watchable.index(true);
        }

        /*
        *  if after debounce you are still to far scrolled down, shift again
        *    TODO: re-enable, for some reason only scrolling down is buggy when attempting to recurse
        */
        // $timeout(function(){
        //   if(_checkScrollDown()) _scrollDown(true);
        // })
      }
    }

    // check if you are far enough up the page to merit a list shift for previous items
    var _checkScrollUp = function _checkScrollUp(){
      return _calcRows() <= 10 && $scope.offset.begin !== 0
    }

    // shift result list by -5 rows
    var _scrollUp = function _scrollUp(bypass) {
      // if you are < 10 rows from the beginning, or the row check is by passed
      if(bypass || _checkScrollUp()){

        // scroll window down by 5 rows
        angWindow.scrollTop(angWindow.scrollTop() + (5 * _rowHeight));

        // shift limitTo offset by -5 rows worth of results
        $scope.offset.begin -= 15;

        // if after debounce you are still to far scrolled up for comfortable UX, shift again bypassing checking twice
        $timeout(function(){
          if(_checkScrollUp()) _scrollUp(true);
        })
      }
    }

    // check scroll position, but only if there hasn't been a new scroll in 100ms
    var _debouncer = delayedExec(100, function() {

      // if USER has scrolled DOWN run scroll down function
      if($scope.offset.new > $scope.offset.last){
        _scrollDown();

      // else if USER has scrolled UP run scroll up function
      } else if($scope.offset.new < $scope.offset.last) {
        _scrollUp();
      }

      // set the last scroll position to be the current scroll position minus the offset of where the list starts on the page
      $scope.offset.last = angWindow.scrollTop() - $scope.offset.firstEl;
    });

    // on currentItem change get the current item position to freeze page for animation effects
    $scope.$watch('currentItem.id', function(){
      $timeout(function(){
        scroll = angWindow.scrollTop();
      });
    })

    // clear state params from url, but don't take action
    var _resetUrl = function _resetUrl(){
      $state.go('list', {}, { notify: false })
    }

    // set the ng-repeat list to be the full index of watchables
    var _setToIndex = function _setToIndex(){
      // _slide down if there is an item being shown
      if($scope.currentItem.id) _slideDown();

      // scroll to top of page and show first item
      _resetOffset();

      //get rid of any lingering url params
      _resetUrl();

      // set transitioning to prevent flash of 'no results'
      $scope.transitioning = true;

      // emit hide item so search controller can do logic if things get out of sync
      // may be unnecessary
      $root.$emit('hideItem');

      // set list back to full index of items
      $scope.list = $scope.watchables;

      // end transitioning state
      $scope.transitioning = false;

      // once at least first page of index has loaded
      // used to prevent overwriting search params coming from show page
      _initialLoaded = true;
    }

    // function also in the search-result directive for in case animations get out of sync
    // collapses full results, then sets currentItem properties to undefined
    var _slideDown = function _slideDown(scope){
      $scope.currentItem.div.removeClass("expanded");
      $scope.currentItem.div.css({position: "", left: "", top: "", width: ""})
      $scope.currentItem.id = void(0);
      $scope.currentItem.div = void(0)
    }

    // function to instantly show search result on exact match
    // does not stop user from continuing to type and search
    var _instantShowItem = function _instantShowItem(item){
      // push execution to end of que so user can see that they're viewing first result
      $timeout(function(){
        // if page is still loading recurse
        if(!$scope.searchResultTracker[item.id]){
          return _instantShowItem(item)
        }

        // run the .show() function for the search-result with the item's id, passing undefined since there is no click event
        $scope.searchResultTracker[item.id](void(0))
      })
    }

    // set list to be the results from a user search query
    var _setSearch = function _setSearch(term) {
      // if the user is currently viewing another result, collapse it
      if($scope.currentItem.id) _slideDown();

      // if the user types another search query before this has executed, cancel the old one
      if(_searchDebounce) $timeout.cancel(_searchDebounce);

      // run the search in an instant timeout, so it can be canceled if the user searches again before the page has loaded
      return _searchDebounce = $timeout(function(){
        // if the full index list hasn't loaded, recurse
        if(!_initialLoaded){
          return _setSearch(term);
        }

        // reset the offset object
        _resetOffset();

        // set transitioning to prevent flash of 'no results'
        $scope.transitioning = true;

        // run the search function of watchableService
        return watchable.search(term).then(function(searchResults){
          // when the search results are returned, clear the url bar (incase they were viewing full result)
          _resetUrl();

          // set the ng-repeat list to be the search results
          $scope.list = searchResults;

          // if there is at least one result, and the first result's title matches the query exactly jump straight to showing the full result
          if(searchResults[0] && searchResults[0].title.toLowerCase() === term.toLowerCase()){
            _instantShowItem(searchResults[0]);
          }

          // set transitioning to false so we can show if there are no results
          $scope.transitioning = false;
        })
      })
    }

    // grab the index of results from the watchable service
    watchable.index().then(function setWatchable(watchables) {
      $scope.watchables = watchables;
      _onResize();
      _setToIndex();
    });

    // grab the tmdbConfig for displaying posters
    tmdbConfig().then(function(sizes){
      $scope.imageSizes = sizes;
    })

    // if search query was set from an external page, set the search
    if($stateParams.searchSet){
      _setSearch($stateParams.searchSet)
        .finally(function(){
          // clear stateParams to avoid lingering param bug in ui-router
          $stateParams.searchSet = null
        })
    }

    var _onScroll = function _onScroll(e){
      // if there is currently a result being shown keep setting window scroll top to be where it was before
      if($scope.currentItem.id){
        angWindow.scrollTop(scroll);

        // else run the debouncer
      } else {

        // set the new scroll position to be the current scroll position minus the offset of where the list starts on the page
        $scope.offset.new = angWindow.scrollTop() - $scope.offset.firstEl;

        // if _rowHeight has been set run
        if(_rowHeight){
          _debouncer();

          // else run the resize function to grab row heights for the next scroll
        } else {
          _onResize();
        }
      }
    }

    // on there being a new search set, run the search
    _handlers.root.push($root.$on('searchSet', function(event, term){
      _setSearch(term)
    }));

    //on clearing out the search terms, switch back to full index
    _handlers.root.push($root.$on('searchClear', _setToIndex));

    // scroll listener
    _setListener(angular.element(document), 'scroll', _onScroll);

    // on window resize recalculate row size for scroll debouncer
    _setListener(angular.element($window), 'resize', _onResize);

    $scope.$on("$destroy", function() {
      var rootHandlers = _handlers.root,
          elementHandlers = _handlers.element;

      for(var i = 0, length = rootHandlers.length; i < length; i++){
        rootHandlers[i]();
      }

      for(var i = 0, length = elementHandlers.length; i < length; i++){
        var item = elementHandlers[i];
        item.el.off(item.ev, item.f);
      }
    });
  }
])
