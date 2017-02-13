qWatch.controller('ListIndexCtrl',[
  '$scope', '$stateParams',
  function($scope, $stateParams){
    $scope.searchResults = [ // TODO: replace with live data
      {
        title: "The Dark Knight",
        posterURL: "http://www.geek.com/wp-content/uploads/2016/02/batmans.jpg"
      },
      {
        title: "Finding Dory",
        posterURL: "https://i.ytimg.com/vi/AMjMFbhyhwY/maxresdefault.jpg"
      },
      {
        title: "Eternal Sunshine of the Spotless Mind",
        posterURL: "http://popcornsushi.com/wp-content/uploads/2016/08/eternal-sunshine-of-the-spotless-mind-6.jpg"
      }
    ]
  }
])
