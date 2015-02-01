controllers = angular.module('controllers')

controllers.controller('LocationsController', [ '$scope', '$routeParams', '$location', '$resource',
	($scope, $routeParams, $location, $resource) ->
		if $routeParams.page
			$scope.page = parseInt($routeParams.page)
		else
			$scope.page = 1

		if $routeParams.query
			$scope.query = $routeParams.query
		else
			$scope.query = null

		Location = $resource('/locations/:locationId',
			recipeId: '@id',
			format: 'json'
		)

		Location.query(query: $scope.query, page: $scope.page, (results) ->
			$scope.locations = results
		)

		$scope.search = (query) ->
			$location.url('/locations').search(query: query)

		$scope.showLocation = (location) ->
			$location.url("/locations/#{location.id}")

		$scope.hasPreviousPage = ->
			$scope.page != 1

		# FIXME: This could do with knowing the total number of pages from the JSON
		# retrieved from the server and using that to determine if there really is a
		# next page. It'll do for now, though.
		$scope.hasNextPage = ->
			true

		$scope.nextPage = ->
			if $scope.hasNextPage()
				$location.search(query: $scope.query, page: $scope.page + 1)
			else
				console.log('No next page. Current page = ' + $scope.page)

		$scope.previousPage = ->
			if $scope.hasPreviousPage()
				$location.search(query: $scope.query, page: $scope.page - 1)
			else
				console.log('No previous page. Current page = ' + $scope.page)
])