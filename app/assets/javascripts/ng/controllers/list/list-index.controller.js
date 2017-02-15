qWatch.controller('ListIndexCtrl',[
  '$scope', '$rootScope', '$timeout', '$window', 'watchableService', "tmdbConfigService",
  function($scope, $root, $timeout, $window, watchable, tmdbConfig){

    var el = document.getElementById('watchable-search'),
        rowHeight = 530,
        scroll = 0;
        console.log(el)

    $scope.currentItem = {};

    $scope.offset = {
      new: 0,
      last: 0,
      begin: 0
    }

    // var _resetOffset = function _resetOffset(){
    //   angular.copy({
    //     new: 0,
    //     last: 0,
    //     begin: 0
    //   }, $scope.offset)
    // }
    //
    // var _calcFirst = function _calcFirst(scroll){
    //   return Math.floor(($scope.offset.new/rowHeight));
    // }
    //
    // var delayedExec = function(after, fn) {
    //     var timer;
    //     return function() {
    //         timer && $timeout.cancel(timer);
    //         timer = $timeout(fn, after);
    //     };
    // };
    //
    // var _debouncer = delayedExec(100, function() {
    //     if($scope.offset.new > $scope.offset.last){
    //       var newOffset = _calcFirst() > 50 ? Math.floor(_calcFirst()/25) - 1 : 0;
    //       $scope.offset.begin += newOffset * 25;
    //       el.scrollTop -= rowHeight * newOffset * 25;
    //     } else if($scope.offset.new < $scope.offset.last) {
    //       var newOffset = _calcFirst() < 50 ? 25 : 0;
    //       if($scope.offset.begin <= newOffset){
    //         el.scrollTop += rowHeight * $scope.offset.begin;
    //         $scope.offset.begin = 0
    //       } else{
    //         $scope.offset.begin -= newOffset;
    //         el.scrollTop += rowHeight * newOffset;
    //       }
    //     }
    //     $scope.offset.last = el.scrollTop;
    // });

    $scope.$watch('currentItem.id', function(){
      $timeout(function(){
        scroll = angular.element($window).scrollTop();
      });
    })

    angular.element(document).on('scroll', function (e) {
      if($scope.currentItem.id){
        angular.element($window).scrollTop(scroll);
      }
      // $scope.offset.new = e.target.scrollTop;
      // _debouncer()
    });

    $scope.next = function next(){
      watchable.index(true);
      $scope.offset.begin += 100;
    }

    $scope.previous = function previous(){
      watchable.index(true);
      $scope.offset.begin -= 100;
    }


    var setToIndex = function setToIndex(){
      $scope.list = $scope.watchables;
    }

    watchable.index().then(function setWatchable(watchables) {
      $scope.watchables = watchables;
      setToIndex();
    });

    tmdbConfig().then(function(sizes){
      $scope.imageSizes = sizes;
    })

    var _slideDown = function _slideDown(scope){
      $scope.currentItem.div.removeClass("expanded");
      $scope.currentItem.div.css({position: "", left: "", top: "", width: ""})
      $scope.currentItem.id = void(0);
      $scope.currentItem.div = void(0)
    }


    $root.$on('searchSet', function(event, term){
      if($scope.currentItem.id) _slideDown();
      watchable.search(term).then(function(searchResults){
        $scope.list = searchResults
      })
    });

    $root.$on('searchClear', setToIndex);

  }
])
