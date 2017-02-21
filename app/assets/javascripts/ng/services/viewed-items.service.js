qWatch.factory('viewedItemsService', [
  '$q', 'Restangular', 'userService',
  function($q, restangular, user){
    "use strict";

    var _viewedItems = [];

    var clear = function clear() {
      angular.copy([], _viewedItems);
    }

    var getAll = function getAll() {
      if (user.signedInUser()) {
        console.log("fetching items")
        if (!_viewedItems.length) {
          restangular
          .all('viewings')
          .getList()
          .then(
            function (response) {
              angular.copy(response, _viewedItems);
              console.log("viewed items", _viewedItems);
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
        restangular
        .one('watch', viewed_id)
        .all('viewings')
        .post()
        .then(
          function (viewedItem) {
            console.log("created viewing,", viewedItem)
            _viewedItems.push(viewedItem);
          },
          function (response) {
            console.log("Viewing Already exists");
          }
        );
      }
    };

    return {
      create: create,
      getAll: getViewedItems,
      fetchAll: getAll,
      clear: clear
    }
  }
]);
