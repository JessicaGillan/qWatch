qWatch.controller('ShareCtrl',[
  '$scope', '$state', '$stateParams', '$rootScope', '$timeout', 'watchableService', 'tmdbConfigService',
  function($scope, $state, $stateParams, $root, $timeout, watchable, tmdbConfig){
    "use strict";

    $root.showPage = false;
    $scope.currentItem = {};
    $scope.searchResultTracker = {};
    tmdbConfig().then(function(sizes){
      $scope.imageSizes = sizes;
      _setSearch($stateParams.title);
    });

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

      // run the search in an instant timeout, so it can be canceled if the user searches again before the page has loaded

      // set transitioning to prevent flash of 'no results'
      $scope.transitioning = true;

      // run the search function of watchableService with strict flag for only exact matches
      return watchable.search(term, true)
      .then(function(searchResults){
        // set the ng-repeat list to be the search results
        $scope.results = searchResults;
        if(searchResults.length === 1){
          _instantShowItem(searchResults[0]);
        }
        // set transitioning to false so we can show if there are no results
        $scope.transitioning = false;
      })
    }


  }
])
