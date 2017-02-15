qWatch.controller('ListIndexCtrl',[
  '$scope', '$rootScope', '$timeout', '$window', '$state', '$stateParams', 'watchableService', "tmdbConfigService",
  function($scope, $root, $timeout, $window, $state, $stateParams, watchable, tmdbConfig){
    console.log("list index ctrl")
    $root.showPage = false;

    var el = angular.element('#watchable-search'),
        scroll = 0,
        angWindow = angular.element($window),
        rowHeight;

    $scope.currentItem = {};

    $scope.offset = {
      new: 0,
      last: 0,
      begin: 0,
      firstEl: el.offset().top
    }

    var _resetOffset = function _resetOffset(){
      angular.copy({
        new: 0,
        last: 0,
        begin: 0
      }, $scope.offset)
    }

    var _onResize = function _onResize(){
      $timeout(function(){
        rowHeight = angular.element('.search-result-wrapper').outerHeight(true);
      })
    }

    var _calcFirst = function _calcFirst(scroll){
      return Math.floor(($scope.offset.new/rowHeight));
    }

    var delayedExec = function(after, fn) {
      var timer;
      return function() {
        timer && $timeout.cancel(timer);
        timer = $timeout(fn, after);
      };
    };

    var _checkScrollDown = function _checkScrollDown(){
      return _calcFirst() >= 15;
    }

    var _scrollDown = function _scrollUp(bypass) {
      if(bypass || _checkScrollDown()){
        angWindow.scrollTop(angWindow.scrollTop() - (5 * rowHeight));
        $scope.offset.begin += 15;
        if(Math.floor(($scope.list.length - $scope.offset.begin)/3) - _calcFirst() < 5){
          watchable.index(true);
        }
        // $timeout(function(){
        //   if(_checkScrollDown()) _scrollDown(true);
        // })
      }
    }

    var _checkScrollUp = function _checkScrollUp(){
      return _calcFirst() <= 10 && $scope.offset.begin !== 0
    }

    var _scrollUp = function _scrollUp(bypass) {
      if(bypass || _checkScrollUp()){
        angWindow.scrollTop(angWindow.scrollTop() + (5 * rowHeight));
        $scope.offset.begin -= 15;
        // $timeout(function(){
        //   if(_checkScrollUp()) _scrollUp(true);
        // })
      }
    }

    var _debouncer = delayedExec(100, function() {
      if($scope.offset.new > $scope.offset.last){
        _scrollDown();
      } else if($scope.offset.new < $scope.offset.last) {
        _scrollUp();
      }
      $scope.offset.last = angWindow.scrollTop() - $scope.offset.firstEl;
    });

    $scope.$watch('currentItem.id', function(){
      $timeout(function(){
        scroll = angWindow.scrollTop();
      });
    })

    angular.element(document).on('scroll', function (e) {
      if($scope.currentItem.id){
        angWindow.scrollTop(scroll);
      } else {
        $scope.offset.new = angWindow.scrollTop() - $scope.offset.firstEl;
        if(rowHeight){
          _debouncer();
        } else {
          _onResize();
        }
      }
    });

    // $scope.next = function next(){
    //   watchable.index(true);
    //   // $scope.offset.begin += 100;
    // }
    //
    // $scope.previous = function previous(){
    //   watchable.index(true);
    //   // $scope.offset.begin -= 100;
    // }


    var setToIndex = function setToIndex(){
      $scope.list = $scope.watchables;
    }

    watchable.index().then(function setWatchable(watchables) {
      $scope.watchables = watchables;
      _onResize();
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

    if($stateParams.searchSet){
      console.log('if statement', $stateParams)
      $root.$emit("fillSearch", $stateParams.searchSet)
      watchable.search($stateParams.search).then(function(searchResults){
        $scope.list = searchResults;
        $stateParams.searchSet = null;
      })
    }

    $root.$on('searchClear', setToIndex);

    angular.element($window).on('resize', _onResize);

  }
])
