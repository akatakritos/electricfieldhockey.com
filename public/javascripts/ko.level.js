(function($){

	var defaults = {
		name : '',
		width : 800,
		height : 450,
		backgroundUrl : '',
		startingCharges : '1,1,1,-1,-1,-1',
		goal : {
			x : 775,
			y: 175,
			width: 25,
			height: 100
		},
		puckPosition : {
			x : 100,
			y : 50
		}
	};

	var Level = function(options) {
		this.name = ko.observable();
		this.width = ko.observable();
		this.height = ko.observable();
		this.backgroundUrl = ko.observable();
		this.startingCharges = ko.observable();
		this.goal = {
			x : ko.observable(),
			y : ko.observable(),
			width : ko.observable(),
			height : ko.observable()
		};
		this.puckPosition = {
			x : ko.observable(),
			y : ko.observable()
		};

		this.load = function( options ) {
			var o = options || {};

			var props = ['name','width','height','backgroundUrl','startingCharges'];
			var self = this;
			props.forEach(function(prop) {
				self[prop](o[prop]);
			});

			for (var p in o.goal) {
				this.goal[p]( o.goal[p] );
			}

			for (p in o.puckPosition) {
				this.puckPosition[p]( o.puckPosition[p] );
			}
		};
	};

	var json = $("#level_json").val();
	var settings = defaults;

	if ( json.length != "" ) {
		try {
			settings = JSON.parse(json);
		} catch (SyntaxError) {
			settings = defaults;
		}
	}

	var level = new Level();
	level.load( settings );

	ko.applyBindings(level);
})(jQuery);
