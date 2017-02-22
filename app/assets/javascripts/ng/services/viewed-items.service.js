qWatch.factory('viewedItemsService', [
  '$q', 'Restangular', 'userService',
  function($q, restangular, user){
    "use strict";

    var _viewedItems = [];
    var _friendsViewedItems = [];
    var _itemsSet = false;

    var clear = function clear() {
      angular.copy([], _viewedItems);
    }

    var getAll = function getAll() {
      if (user.signedInUser()) {

        if (!_viewedItems.length) {
          restangular
          .all('viewings')
          .getList()
          .then(
            function (response) {
              angular.copy(response, _viewedItems);
              _itemsSet = true;
            },
            function (response) {
              console.error("Could not retrieve Viewed Items", response.message);
            }
          );
        }
      } else {
        console.log("user not signed in")
      }
    }

    var getViewedItems = function getViewedItems() {
      return _viewedItems
    }

    var create = function create(tmdb_id, tmdb_type) {
      if (user.signedInUser()) {

        if (!_itemsSet) getAll();

        if (!includedInViewed(tmdb_id, tmdb_type)) {
          restangular
          .one('watch', tmdb_id)
          .all('viewings')
          .post({ tmdb_type: tmdb_type })
          .then(
            function (viewedItem) {
              if (viewedItem) _viewedItems.unshift(viewedItem);
            },
            function (response) {
              console.log("Viewing Already exists");
            }
          );
        }
      }
    };

    // Avoid making unnecessary post request for already viewed items,
    // will still try to make a request while viewed items are loading
    var includedInViewed = function includedInViewed(tmdb_id, tmdb_type) {
      for (var i = 0; i < _viewedItems.length; i++) {
        console.log(_viewedItems[i].tmdb_id, tmdb_id)
        if (_viewedItems[i].tmdb_id === parseInt(tmdb_id) &&
            _viewedItems[i].tmdb_type === tmdb_type) {
          return true;
        }
      }

      return false
    }

    var fetchFriends = function fetchFriends() {
      if (user.signedInUser()) {

        if (!_friendsViewedItems.length) {
          restangular
          .all('viewings')
          .getList({ "friends_viewings": true })
          .then(
            function (response) {
              angular.copy(response, _friendsViewedItems);
            },
            function (response) {
              console.error("Could not retrieve Viewed Items", response.message);
            }
          );
        }
      } else {
        console.log("user not signed in")
      }
    }

    var getFriends = function getFriends() {
      return _friendsViewedItems
    }

    return {
      create: create,
      getAll: getViewedItems,
      fetchAll: getAll,
      clear: clear,
      getFriends: getFriends,
      fetchFriends: fetchFriends
    }
  }
]);
