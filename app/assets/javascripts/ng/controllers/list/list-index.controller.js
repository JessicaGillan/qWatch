qWatch.controller('ListIndexCtrl',[
  '$scope', '$stateParams',
  function($scope, $stateParams){
    $scope.searchResults = [ // TODO: replace with live data
      {
        id: 1,
        title: "The Dark Knight",
        poster: "http://www.geek.com/wp-content/uploads/2016/02/batmans.jpg"
      },
      {
        id: 2,
        title: "Finding Dory",
        poster: "https://i.ytimg.com/vi/AMjMFbhyhwY/maxresdefault.jpg"
      },
      {
        id: 3,
        title: "Eternal Sunshine of the Spotless Mind",
        poster: "http://popcornsushi.com/wp-content/uploads/2016/08/eternal-sunshine-of-the-spotless-mind-6.jpg"
      }
    ]
  }
])
