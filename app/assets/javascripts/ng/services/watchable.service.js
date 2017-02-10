qWatch.factory('watchableService', [
  'Restangular',
  function(restangular){
    var _watchables = [],
        _searchResults = [],
        _paginate = 0;

    var _denormalize = function _denormalize(arr, newArr, offset){
      offset = offset || 0;
      for(var i = 0; i < arr.length; i++){
        arr[i].idx = i + offset;
        newArr.push(arr[i]);
      }
    }

    var _complete = function _complete(watchable, result){
      angular.copy(result, watchable);
      watchable.complete = true;
    }

    var index = function index(next_page){
      if(!_watchables.length || next_page){
        return restangular
          .all('watchable')
          .getList({start: _paginate})
          .then(function(results){
            _denormalize(results, _watchables, _paginate);
            _paginate += results.length;
            return _watchables;
          });
      }
      return $q.resolve(_watchables)
    }

    var show = function show(idx){
      var watchable = _watchables[idx];
      if(!watchable.complete){
        return restangular
          .one('watchable', watchable.id)
          .get()
          .then(function(result){
            _complete(watchable, result)
            return watchable;
          })
      }
      return $q.resolve(watchable);
    }

    var search = function search(term){
      _searchResults.length = 0;
      return restangular
        .all('search')
        .getList({search: term})
        .then(function(results){
          _denormalize(results, _searchResults)
          return _searchResults;
        })
    }

    return {
      index: index,
      show: show
    }
  }
]);