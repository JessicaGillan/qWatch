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
    };

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
