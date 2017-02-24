# qWatch
Share qWatch Links to show what sites your favorite movies are streaming on.

[https://qwatch.me](https://qwatch.me)

## Using qWatch
1. Search on the home page for movies by title
2. If we find the exact title you've entered we'll take you right to that movie,
   but you can also get to a movie by clicking on a search result.
3. Click the 'X' in the top right corner to go back to all results.

## Once you've found the movie you're looking for ....
* View it on your streaming site of choice by following the third pary links!
* Share the qWatch Link to friends, so they can choose which site to stream it from!
  (ie Netflix, Hulu, Xfinity, etc.)
  * Share directly to Facebook, Twitter, or through Email
  * OR easily copy the link to your clipboard to go share wherever you choose!
  
## Want to track movies you've shared or viewed AND see what your friends have been watching? - Sign up for an account!
* Sign in with a good 'ol email address and password OR take advantage of one click signup with Facebook
* Once you are signed in the movies you view or share will be added to your activiyt
* Click 'Show Recent Activity' on the upper left side of the Navigation bar to see your activity
* If you connect to Facebook you will also see a list of movies your friends have been viewing
  
## Want to share movies even faster with qWatch? - Install our Chrome Plugin!
The qWatch Chrome Plugin will add a 'qWatch' logo at the bottom right of your Netflix movie player,
clicking that logo will take you to that movie on qWatch.me so you can share link with friends.

1. Set 'Developer Mode' in Chrome Extensions
2. 'Load' the unpacked extension
3. Look for the qWatch logo on your Netflix player

## Technical Overview
The goal of this project was to give people a quick way to find their favorite movies, stream them on whatever service they prefer, and share them with friends, all with a great user experience. 

### Tools & Features
* Ruby on Rails
* Postgres - SQL Database
* AngularJS - Front End Single Page App Framework
* The Movie Database API
* Guidebox API
* Javascript and CSS animations
* Search - Postgres Trigram indexing and generalized inversed indexing (GIN)
* OmniAuth - Multiple Authentication methods for single account
* Sharing - Modal dialogs for Twitter, Facebook, Email, and Copy-to-Clipboard sharing
* Activity Feed - When signed in, keep track of the movies you've watched and shared
* Friend Activity - See your Friends' activity since your last login
* Chrome Extension API - Share movies as you watch them on netflix via an In-Player link.
* Client Side Authentication - Never leave the SPA
* Devise - Backend Authentication management & processing
* CSRF protection - Ensure your data stays secure even with a SPA
* Optimized Infinite Scrolling - Combined Infinited Scrolling with Pagination ensures the browser is never overloaded with listeners
* RSpec Ruby Testing - Ensure the API works correctly
* Jasmine Javascript Testing - Angular Controller Tests

## Contributions

[Jessica Gillan](https://github.com/JessicaGillan)

[Sampson Crowley](https://github.com/SampsonCrowley)

[Pramod Jacob](https://github.com/domarpj)

### Other Credits
[The Movie Database](https://www.themoviedb.org/?language=en)

[Guidebox](https://api.guidebox.com)
