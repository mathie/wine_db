controllers = angular.module('controllers')

controllers.controller('NavigationController', [ '$scope', '$location',
	($scope, $location) ->
		$scope.isActiveExact = (path) ->
			$location.path() == path

		$scope.isActive = (path) ->
			$location.path().indexOf(path) == 0

		$scope.rootPath = ->
			$location.path('/')

		$scope.producersPath = ->
			$location.path('/producers')
])