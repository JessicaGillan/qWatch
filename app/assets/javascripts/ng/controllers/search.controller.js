qWatch.controller('SearchCtrl',[
  '$scope', '$rootScope', '$timeout', '$window',
  function($scope, $root, $timeout, $window){
    console.log('init search')
    var _handler, searchBar,
        searchEl = angular.element('#search-panel'),
        searchElFiller = angular.element('#search-panel-filler'),
        rect = searchEl.get(0).getBoundingClientRect(),
        offset = searchEl.offset().top - rect.height,
        showing = false,
        initial = true;

    $scope.search = {term: ""};

    var searchFor = function searchFor(term){
      if(!initial){
        if(_handler) $timeout.cancel(_handler);

        _handler = $timeout(function(){
          if(term.length === 0){
            $root.$emit('searchClear')
          } else if(term.length > 2) {
            $root.$emit('searchSet', term)
          }
        }, 300)
      }
      initial = false;
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

    $scope.$watch('search.term', searchFor)

    $root.$on('searchSet', _slideUp);
    $root.$on('showItem', _slideUpFixed);

    $root.$on('searchClear', _slideDown);
    $root.$on('hideItem', _slideDown);

    angular.element(document).on('scroll', function (e) {

      if(_checkSearchElPosition()){
        _setSearchElFixed();
      } else {
        _resetSearchEl();
      }
    });
  }
])
