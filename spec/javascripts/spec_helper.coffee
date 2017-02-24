#= require application
#= require angular-mocks
#= require sinon
#= require jasmine-sinon

customMatchers =
  toEqualData: () ->
    compare: (actual, expected) ->
      pass: angular.equals(actual, expected);
    negativeCompare: (actual, expected) ->
      pass: !angular.equals(actual, expected);
  toBeA: () ->
    compare: (actual, expected) ->
      pass: (typeof actual == expected)
    negativeCompare: (actual, expected) ->
      pass: (typeof actual != expected)
  anyOf: () ->
    compare: (actual, key, expected) ->
      pass: (_.some(actual, [key, expected]))
      message: "Expect any item in array to have k,v pair: #{key}=#{expected}"
    negativeCompare: (actual, key, expected) ->
      pass: !(_.some(actual, [key, expected]))
      message: "Expect no item in array to have k,v pair: #{key}=#{expected}"


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
