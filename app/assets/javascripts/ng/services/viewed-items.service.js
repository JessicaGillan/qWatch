qWatch.factory('viewedItemsService', [
  '$q', 'Restangular', 'userService',
  function($q, restangular, user){
    "use strict";

    var _viewedItems = [];
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
      }
      console.log("user not signed in")
    }

    var getViewedItems = function getViewedItems() {
      return _viewedItems
    }

    var create = function create(viewed_id) {
      if (user.signedInUser()) {

        if (!_itemsSet) getAll();

        if (!includedInViewed(viewed_id)) {
          restangular
          .one('watch', viewed_id)
          .all('viewings')
          .post()
          .then(
            function (viewedItem) {
              _viewedItems.push(viewedItem);
            },
            function (response) {
              console.log("Viewing Already exists");
            }
          );
        }
      }
    };

    var includedInViewed = function includedInViewed(viewed_id) {
      for (var i = 0; i < _viewedItems.length; i++) {
        if (_viewedItems[i].id == viewed_id) return true;
      }

      return false
    }

    return {
      create: create,
      getAll: getViewedItems,
      fetchAll: getAll,
      clear: clear
    }
  }
]);
