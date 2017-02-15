qWatch.controller('SearchCtrl',[
  '$scope', '$rootScope', '$timeout', '$window',
  function($scope, $rootScope, $timeout, $window){
    var _handler, searchBar,
        searchEl = angular.element('#search-panel'),
        searchElFiller = angular.element('#search-panel-filler'),
        rect = searchEl.get(0).getBoundingClientRect(),
        offset = searchEl.offset().top - rect.height,
        showing = false;

    $scope.search = {term: ""};

    var searchFor = function searchFor(term){
      if(_handler) $timeout.cancel(_handler);

      _handler = $timeout(function(){
        if(!term || term.length < 3){
          $rootScope.$emit('searchClear')
        } else {
          $rootScope.$emit('searchSet', term)
        }
      }, 300)
    };

    var _resetSearchEl = function _resetSearchEl(){
      $scope.showFiller = false
      searchEl.css({position: "", top: "", width: ""})
    }

    var _checkSearchElPosition = function _checkSearchElPosition(){
      return (angular.element($window).scrollTop() >= offset - 60 && !showing)
    }

    var _setSearchElFixed = function _setSearchElFixed(){
      searchEl.css({transitionDuration: "0s", position: "fixed", top: "51px", width: rect.width})
      $scope.showFiller = true;
    }

    var _slideUp = function _slideUp(){
      _slideDown();
      showing = true;
      _resetSearchEl();
      angular.element('#header-wrapper').css({"max-height": 0, padding: 0});
    }

    var _slideUpFixed = function _slideUpFixed(){
      _slideUp();
      searchBar = searchBar || angular.element('.title-search');
      var srect = searchBar.get(0).getBoundingClientRect();

      searchBar.css({position: "fixed", top: srect.top, width: srect.width})
      $timeout(function(){
        searchBar.css({top: "51px"})
      })
    }

    var _slideDown = function _slideDown(){
      showing = false;
      angular.element('#header-wrapper').css({"max-height": "", padding: ""});
      searchBar = searchBar || angular.element('.title-search');
      searchBar.css({position: "", left: "", top: "", width: ""})
      if(_checkSearchElPosition()) _setSearchElFixed();
    }

    // Do Not call searchFor on page load
    var initializing = true

    $scope.$watch('search.term', function () {
      if (initializing) {
        initializing = false;
      } else {
        searchFor
      }
    });

    $rootScope.$on('searchSet', _slideUp);
    $rootScope.$on('showItem', _slideUpFixed);

    $rootScope.$on('searchClear', _slideDown);
    $rootScope.$on('hideItem', _slideDown);


    angular.element(document).on('scroll', function (e) {

      if(_checkSearchElPosition()){
        _setSearchElFixed();
      } else {
        _resetSearchEl();
      }
    });
  }
])
