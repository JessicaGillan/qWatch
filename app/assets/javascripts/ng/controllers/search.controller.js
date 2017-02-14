qWatch.controller('SearchCtrl',[
  '$scope', '$rootScope', '$timeout',
  function($scope, $rootScope, $timeout){
    var _handler, searchBar;

    $scope.search = {term: ""};

    var searchFor = function searchFor(term){
      if(_handler) $timeout.cancel(_handler);

      _handler = $timeout(function(){
        if(!term){
          $rootScope.$emit('searchClear')
        } else {
          $rootScope.$emit('searchSet', term)
        }
      }, 300)
    };

    var _slideUp = function _slideUp(){
      _slideDown();
      angular.element('#header-wrapper').css({"max-height": 0, padding: 0});
    }

    var _slideUpFixed = function _slideUpFixed(){
      _slideUp();
      searchBar = searchBar || angular.element('.title-search');
      var rect = searchBar.get(0).getBoundingClientRect();
      searchBar.css({position: "fixed", left: rect.left, top: rect.top, width: rect.width})
      $timeout(function(){
        searchBar.css({top: "51px"})
      })
    }

    var _slideDown = function _slideDown(){
      angular.element('#header-wrapper').css({"max-height": "", padding: ""});
      searchBar = searchBar || angular.element('.title-search');
      searchBar.css({position: "", left: "", top: "", width: ""})
    }

    $scope.$watch('search.term', searchFor)

    // When search bar is no longer pristine, remove title/logo and
    // slide form upwards.
    $rootScope.$on('searchSet', _slideUp);
    $rootScope.$on('showItem', _slideUpFixed);

    $rootScope.$on('searchClear', _slideDown);
    $rootScope.$on('hideItem', _slideDown);
  }
])
