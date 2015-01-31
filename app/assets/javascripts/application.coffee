#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require angular/angular
#= require angular-route/angular-route
#= require angular-rails-templates
#= require_self
#= require_tree .

wineDB = angular.module('wineDB', [
	'templates',
	'ngRoute',
	'controllers'
])

wineDB.config([ '$routeProvider',
	($routeProvider) ->

		$routeProvider
			.when('/',
				templateUrl: 'pages/index.html'
				controller: 'PagesController'
			)
])

controllers = angular.module('controllers', [])
