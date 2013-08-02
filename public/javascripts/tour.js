(function(){
	$(document).ready(function(){
		var initLevel = {
			"width" : 800,
			"height" : 450,
			"goal" : {
				"x": 775,
				"y": 175,
				"width": 25,
				"height": 100
			},
			"puckPosition" : {
				"x" : 100,
				"y": 225
			},
			"startingCharges" : []
		};

		var positiveLevel = {
			"width" : 800,
			"height" : 450,
			"goal" : {
				"x": 600,
				"y": 175,
				"width": 25,
				"height": 100
			},
			"puckPosition" : {
				"x" : 400,
				"y": 225
			},
			"startingCharges" : [1]
		};

		var negativeLevel = {
			"width" : 800,
			"height" : 450,
			"goal" : {
				"x": 600,
				"y": 175,
				"width": 25,
				"height": 100
			},
			"puckPosition" : {
				"x" : 400,
				"y": 225
			},
			"startingCharges" : [-1]
		};

		var curveLevel = {
			"width" : 800,
			"height" : 450,
			"goal" : {
				"x": 775,
				"y": 350,
				"width": 25,
				"height": 100
			},
			"backgroundUrl" : "/img/bg-tour-1.png",
			"puckPosition" : {
				"x" : 115,
				"y": 385
			},
			"startingCharges" : [1,1,1,1,1,-1,-1,-1,-1,-1]
		};

		var offset = $('#playground').offset();
		offset.left += 100;

		var steps = [
			{
				content: "<p>This is the puck. It has a positive charge. Remember your high school physics?</p>",
				target: [offset.left + initLevel.puckPosition.x, offset.top + initLevel.puckPosition.y-25],
				nextButton: true,
				my: 'bottom center',
				setup: function(tour, options) {

					$('#toolbar').css('visibility', 'hidden');

					EFH.createGame({ container: 'playground'}, function(game) {
						game.init( initLevel );
						window.sim = game;
						game.reset();
					});
				}
			},
			{
				content: '<p>This is the goal. You will try to navigate the puck so that it comes in contact with the goal.</p>',
				target: [offset.left + initLevel.goal.x - 25, offset.top + initLevel.goal.y + initLevel.goal.height/2],
				nextButton: true,
				my: 'right center',
			},
			{
				content: "<p>The Start button will start or stop the game</p>",
				target: $('#stop'),
				my : 'top left',
				at : 'bottom center',
				setup: function(tour, options) {
					$('#toolbar').css('visibility', 'visible');
				},
				nextButton: true
			},
			{
				content: '<p>The Reset button returns the puck to the initial position.</p>',
				target: $('#reset'),
				my: 'top left',
				at: 'bottom center',
				nextButton: true
			},
			{
				content: '<p>This is a positive charge</p><p>Remember that the puck also has a positive charge.' +
						' Since like charges repel, the positive charge will push the puck away.</p>' +
						'<p class="action"> Go ahead and try to push the puck into the goal!</p>',
				target : [ offset.left - 50, offset.top + 20],
				my : 'left top',
				setup: function(tourd, options) {
					window.sim.init( positiveLevel );
					window.sim.on('win', function(){
						tourd.next();
					});
				},
				skipButton: true
			},
			{
				content: '<p>This is a negative charge</p><p>This time, the charge will attract the puck.</p>' +
						'<p class="action"> Go ahead and try to pull the puck into the goal!</p>',
				target : [ offset.left - 50, offset.top + 20],
				my : 'left top',
				setup: function(tourd, options) {
					window.sim.init( negativeLevel );
					window.sim.on('win', function(){
						tourd.next();
					});
				},
				skipButton: true
			},
			{
				content: '<p>By using both types of charges you can curve the puck around obstacles like this one.</p>' +
						'<p class="action">If you can beat this, you are a true master.</p>',
				target : [ offset.left - 50, offset.top + 20],
				my : 'left top',
				setup: function(tourd, options) {

					if (typeof ga !== 'undefined' ) {
						ga('send','event','Tour','Started Last Level');
					}
					window.sim.init( curveLevel );
					window.sim.on('win', function(){
						if ( typeof ga !== 'undefined' ) {
							ga('send', 'event', 'Tour', 'Complete');
						}

						$("#win-modal").modal();
					});
				},
				nextButton: true
			}
		];

		var tour = new Tourist.Tour({
			steps: steps,
			tipOptions: { showEffect: 'slidein' }
		});

		tour.start();
	});

})();