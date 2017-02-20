qWatch.factory('viewedItemsService', [
  '$q', 'Restangular', 'userService',
  function($q, restangular, user){
    "use strict";

    var _viewedItems = [];

    var create = function create(viewed_id) {
      if (user.signedInUser) {
        restangular
        .one('watch', viewed_id)
        .all('viewings')
        .post()
        .then( function (viewedItem) {
          console.log("created viewing,", viewedItem)
          _viewedItems.push(viewedItem);
        })
      }
    };

    return {
      create: create,
    }
  }
]);
