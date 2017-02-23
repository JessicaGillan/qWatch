#= require application
#= require angular-mocks
#= require sinon
#= require jasmine-sinon

customMatchers =
  toEqualData: (expected) ->
    compare: (actual, expected) ->
      pass: angular.equals(actual, expected);
    negativeCompare: (actual, expected) ->
      pass: !angular.equals(actual, expected);


beforeEach(module('qWatch'))
beforeEach ->
  jasmine.addMatchers(customMatchers);


beforeEach inject (_$httpBackend_, _$compile_, $window, $rootScope, $controller, $location, $injector, $timeout, $state, _) ->
  @window = $window
  @windowStub =
    location:
      href: "something"
  
  @scope = $rootScope.$new()
  @root = $rootScope
  @state = $state
  @http = _$httpBackend_
  @compile = _$compile_
  @location = $location
  @controller = $controller
  @injector = $injector
  @timeout = $timeout
  @_ = _
  @model = (name) =>
    @injector.get(name)
  @eventLoop =
    flush: =>
      @scope.$digest()
  @sandbox = sinon.sandbox.create()

afterEach ->
  @http.verifyNoOutstandingExpectation()
  @http.resetExpectations()
