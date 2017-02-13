qWatch.controller('ListShowCtrl',[
  '$scope',
  function($scope){
    // TODO: get actual values from showItemService
    // TODO: move to ListShowCtrl
    $scope.title = "The Dark Knight (2008)"
    $scope.backgroundImg = "http://www.geek.com/wp-content/uploads/2016/02/batmans.jpg"
    $scope.services = [
      {
        name: "Netflix",
        logo: "http://www.underconsideration.com/brandnew/archives/netflix_app_icon.jpg",
        link: "#"
      },
      {
        name: "Netflix",
        logo: "http://phandroid.s3.amazonaws.com/wp-content/uploads/2014/09/amazon-instant-video-icon.png",
        link: "#"
      },
      {
        name: "Hulu",
        logo: "https://cdn2.iconfinder.com/data/icons/metro-ui-dock/512/Hulu.png",
        link: "#"
      }
    ]

    $scope.copyLink = function() {
      return 'http://localhost:3000/#!/watch/' + $stateParams.id
    }
  }
])
