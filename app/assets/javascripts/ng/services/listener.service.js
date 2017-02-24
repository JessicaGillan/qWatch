qWatch.factory('listenerService', [
  '$rootScope',
  function($root){
    var _listeners = {
      controller: {},
      service: {},
      directive: {}
    }

    var _setIfNotExists = function _setIfNotExists(type, name){
      if(!_listeners[type][name]) _listeners[type][name] = {root: [], element: []}
    }
    // event listener wrapper to also setup deregistration
    var setElementListener = function setElementListener(type, name, el, ev, f){
      _setIfNotExists(type, name);
      el.on(ev, f);
      _listeners[type][name].element.push({el: el, ev: ev, f: f})
    }

    var setRootListener = function setRootListener(type, name, ev, f) {
      _setIfNotExists(type, name);
      _listeners[type][name].root.push($root.$on(ev, f))
    }

    var destroy = function destroy(type, name){
      if(!_listeners[type][name]) return;

      var rootHandlers    = _listeners[type][name].root,
          elementHandlers = _listeners[type][name].element;

      for(var i = 0, length = rootHandlers.length; i < length; i++){
        rootHandlers[i]();
      }
      rootHandlers.splice(0, rootHandlers.length)

      for(var i = 0, length = elementHandlers.length; i < length; i++){
        var item = elementHandlers[i];
        item.el.off(item.ev, item.f);
      }
      elementHandlers.splice(0, elementHandlers.length)
    }

    return {
      element: setElementListener,
      root: setRootListener,
      destroy: destroy
    }
  }
])
