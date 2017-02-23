#= require spec_helper

describe 'Search Controller', ->
  beforeEach ->

    @controller 'SearchCtrl',
      $scope: @scope,
      $root: @root,
      $timeout: @timeout,
      listeners: @model('listenerService')

  describe 'load', ->
    it 'sets an empty search object', ->
      expect @scope.search
        .toEqualData term: ""

    it 'initializes a scope watcher on the search term', ->
      expect @scope.$$watchers
        .anyOf('exp', 'search.term')

    it 'sets root listeners for search events', ->
      expect @root.$$listeners["searchSet"]
        .toEqual jasmine.any Array
      expect @root.$$listeners["showItem"]
        .toEqual jasmine.any Array
      expect @root.$$listeners["hideItem"]
        .toEqual jasmine.any Array

    it 'sets a scroll listener on the document for sticky search', ->
      eventListeners = angular.element._data(angular.element(document)[0], "events");
      console.log(eventListeners);
      expect(true).toEqual false
