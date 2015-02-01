#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require angular/angular
#= require angular-route/angular-route
#= require angular-resource/angular-resource
#= require angular-rails-templates
#= require_self
#= require_tree .

wineDB = angular.module('wineDB', [
	'templates',
	'ngRoute',
	'ngResource',
	'controllers'
])

wineDB.config([ '$routeProvider',
	($routeProvider) ->

		$routeProvider
			.when('/',
				templateUrl: 'pages/index.html'
				controller: 'PagesController'
			).when('/producers',
				templateUrl: 'producers/index.html'
				controller: 'ProducersController'
			).when('/producers/:producerId',
				templateUrl: 'producers/show.html'
				controller: 'ProducerController'
			).otherwise(
				redirectTo: '/'
			)
])

controllers = angular.module('controllers', [])
