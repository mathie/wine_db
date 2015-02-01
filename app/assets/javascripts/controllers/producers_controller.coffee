controllers = angular.module('controllers')

controllers.controller('ProducersController', [ '$scope', '$routeParams', '$location', '$resource',
	($scope, $routeParams, $location, $resource) ->
		if $routeParams.page
			$scope.page = parseInt($routeParams.page)
		else
			$scope.page = 1

		if $routeParams.query
			$scope.query = $routeParams.query
		else
			$scope.query = null

		Producer = $resource('/producers/:producerId',
			recipeId: '@id',
			format: 'json'
		)

		Producer.query(query: $scope.query, page: $scope.page, (results) ->
			$scope.producers = results
		)

		$scope.search = (query) ->
			$location.url('/producers').search(query: query)

		$scope.showProducer = (producer) ->
			$location.url("/producers/#{producer.id}")

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