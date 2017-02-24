qWatch.directive('copyLink', [
  '$window', 'viewedItemsService',
  function ($window, viewed) {
    "use strict";

    var _createActivity = function _createActivity(msg, watchable){
      if(msg.type === "success"){
        viewed.create(watchable.tmdb_id, watchable.tmdb_type, 'shared')
      }
    }

    //  A work around to copy text to the clipboard without displaying
    // an input / textarea element.
    // (basically insert element, copy to clipboard, remove element):
    var copyTextToClipboard = function copyTextToClipboard(text) {
      var textArea = document.createElement("textarea");

      //
      // *** This styling is an extra step which is likely not required. ***
      // The likelihood is the element won't even render, not even a flash,
      // so some of these are just precautions. However in IE the element
      // is visible whilst the popup box asking the user for permission for
      // the web page to copy to the clipboard.
      //

      // Place in top-left corner of screen regardless of scroll position.
      textArea.classList.add('no-show');


      textArea.value = text;

      document.body.appendChild(textArea);

      textArea.select();

      var msg;
      try {
        var successful = document.execCommand('copy');
        msg = successful ? 'successful' : 'unsuccessful';
        console.log('Copying text command was ' + msg);
        msg = { type: "success", text: "✓ Copied to clipboard"};
      } catch (err) {
        console.log('Oops, unable to copy');
        msg = { type: "error", text: "Oops, unable to copy"};
      }

      document.body.removeChild(textArea);

      return msg;
    }

    var copyLink = function copyLink(watchable) {
      var text = watchable ? $window.location.protocol + "//" + $window.location.host + "/#!/watch/" + watchable.tmdb_type + "/" + watchable.tmdb_id : location.href;

      return copyTextToClipboard(text);
    }

    return {
      restrict: 'E',
      scope: {
        watchable: '='
      },
      templateUrl: 'ng/directives/copy-link.html',
      link: function(scope, element, attrs) {
        scope.copyLinkAction = function (e) {
          e.preventDefault();

          var msg = copyLink(scope.watchable);

          scope.type = msg.type;
          scope.text = msg.text;
          _createActivity(msg, scope.watchable);

          element.children('#center-flash').first().trigger('flashSet');
        }
      }
    };
  }
]);
