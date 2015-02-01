controllers = angular.module('controllers')

controllers.controller('ProducerController', [ '$scope', '$routeParams', '$location', '$resource',
	($scope, $routeParams, $location, $resource) ->
		Producer = $resource('/producers/:producerId',
			producerId: "@id"
			format: 'json'
		)

		if $routeParams.producerId
			Producer.get({ producerId: $routeParams.producerId },
				( (producer) -> $scope.producer = producer ),
				( (httpResponse) ->
					$scope.producer = null
				)
			)
])