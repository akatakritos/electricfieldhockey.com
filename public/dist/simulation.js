(function(window) {
	var EFH = window.EFH || {};
	if ( typeof window.EFH === 'undefined' ) {
		window.EFH = EFH;
	}
;var merge = function(defaults, overrides) {
	if (overrides) {
		for ( var prop in overrides ) {
			if (defaults.hasOwnProperty(prop)) {
				defaults[prop] = overrides[prop];
			}
		}
	}
};
;var Vector = function(options) {
	//defaults
	this.magnitude = 0;
	this.direction = 0;

	merge(this, options);
};

Vector.prototype.toString = function() {
	return "Vector: " + this.magnitude.toFixed(2) + " @ " + (180*this.direction/Math.PI).toFixed(2);
};

Vector.prototype.add = function( that ) {
	if (that.magnitude === 0) {
		return new Vector({
			magnitude: this.magnitude,
			direction: this.direction
		});
	}
	var x = this.xComponent() + that.xComponent();
	var y = this.yComponent() + that.yComponent();

	var dir = Math.atan2(y, x);
	var magnitude = Math.sqrt((x * x) + (y * y));
	return new Vector({
		magnitude: magnitude,
		direction : dir
	}).standardize();
};

Vector.prototype.mult = function (scalar) {
	return new Vector({
		magnitude: this.magnitude * scalar,
		direction: this.direction
	}).standardize();
};

Vector.prototype.xComponent = function() {
	return this.magnitude * Math.cos( this.direction );
};

Vector.prototype.yComponent = function() {
	return this.magnitude * Math.sin( this.direction );
};

Vector.ZERO = new Vector({magnitude: 0, direction: 0});

Vector.prototype.standardize = function() {
	var direction = this.direction;
	var magnitude = this.magnitude;

	//standardize magnitude to be positive
	if( magnitude < 0 ) {
		magnitude = Math.abs( magnitude );
		direction += Math.PI;
	}

	//normalize direction to between 0 and 2pi
	var delta = direction < 0 ? 2*Math.PI : (-2*Math.PI);
	while (direction < 0 || direction > 2*Math.PI) {
		direction += delta;
	}

	var result = new Vector({magnitude: magnitude, direction:direction});
	result.nonstandard = this;
	return result;
};

Vector.fromComponent = function(x, y) {
	return new Vector({
		magnitude: Math.sqrt(x*x + y*y),
		direction: Math.atan2(y, x)
	}).standardize();
};

EFH.Vector = Vector;;var K = 1000000; //force constant

var PointCharge = function(options) {

	this.x = 0;
	this.y = 0;
	this.charge = 1;

	merge(this, options);
};

PointCharge.prototype.calcForceAgainst = function(otherCharge) {
	var dx = otherCharge.x - this.x;
	var dy = otherCharge.y - this.y;
	var r  = Math.sqrt(dx*dx + dy*dy);

	var dir = Math.atan2(dy, dx);

	var magnitude = K * this.charge * otherCharge.charge / (r * r);

	if ( magnitude == Number.POSITIVE_INFINITY) {
		magnitude = Number.MAX_VALUE;
	}

	return new Vector({magnitude: magnitude, direction: dir}).standardize();
};

PointCharge.prototype.calcForceFrom = function( pointCharges ) {
	var onObj = this;
		if (pointCharges.length === 0) {
			return Vector.ZERO;
		}

		return pointCharges.map(function( pointCharge ){

			return pointCharge.calcForceAgainst( onObj );

		}).reduce(function(accumulator, v, i, arr) {
			return accumulator.add(v);
		}, Vector.ZERO).standardize();
	};

EFH.PointCharge = PointCharge;
EFH.K = K;;/**
 * Namespace for physics functions
 * @type {Object}
 */
	var Physics = {};

	/**
	 * Calculate the position of an object after a period of time.
	 *
	 * p = p0 + vt + at^2
	 * 
	 * @param  {object|Point}  p    {x,y} initial position
	 * @param  {EFH.Vector}    v    velocity vector
	 * @param  {EFH.Vector}    a    acceleration vector
	 * @param  {Number}        t    time in seconds
	 * @return {object}             {x, y} final position
	 */
	Physics.calcPosition = function(p, v, a, t) {
		return {
			x : p.x + (v.xComponent() * t + a.xComponent() * (t*t)),
			y : p.y + (v.yComponent() * t + a.yComponent() * (t*t))
		};
	};

	/**
	 * Calculates the velocity of an object after a period of time
	 *
	 * v = v0 + at
	 * 
	 * @param  {EFH.Vector}   v    initial velocity Vector
	 * @param  {EFH.Vector}   a    acceleration vector
	 * @param  {Number}       t    time passed in seconds
	 * @return {EFH.Vector}        final velocity vector
	 */
	Physics.calcVelocity = function(v, a, t) {
		return v.add( a.mult(t) );
	};

	EFH.Physics = Physics;
;	var Simulation = function(initialState, onStep) {
		this.charges = [];
		this.initialState = initialState;
		this.currentState = initialState;
		this.previousState = initialState;
		this.accumulator = 0;
		this.simrate = 1000/60; //fps
		this.onStep = onStep || function( state, frame ) {};
	};

	Simulation.prototype.reset = function() {
		this.currentState = this.previousState = this.initialState;
		this.accumulator = 0;
	};

	Simulation.prototype.step = function( state, ds ) {
		var dt = ds/1000;
		if (dt === 0) {
			return state;
		}
		var force = new PointCharge({x:state.position.x, y:state.position.y, charge: state.charge.charge}).calcForceFrom( this.charges );
		var position = Physics.calcPosition( state.position, state.velocity, force, dt);
		var acceleration = force; //assume mass = 1
		var velocity = Physics.calcVelocity( state.velocity, force, dt);
		return {
			position: position,
			velocity: velocity,
			acceleration: acceleration,
			charge : state.charge
		};
	};

	Simulation.prototype.handleFrameRequest = function( frame ) {
		var frameTime = frame.timeDiff > 250 ? 250 : frame.timeDiff;
		this.accumulator += frameTime;
		while( this.accumulator >= this.simrate ) {

			this.previousState = this.currentState;
			this.currentState  = this.step( this.currentState, this.simrate );
			this.accumulator  -= this.simrate;

			this.onStep( this.currentState, frame );
			
		}

		var alpha = this.accumulator / frameTime;
		var state = this.blend(this.previousState, this.currentState, alpha);

		return state;
	};

	Simulation.prototype.blend = function( previousState, currentState, alpha ) {
		//currentState*alpha + previousState * ( 1.0 - alpha );
		var previousPositionVector = Vector.fromComponent(previousState.position.x, previousState.position.y);
		var currentPositionVector = Vector.fromComponent(currentState.position.x, currentState.position.y);
		var blendedPositionVector = currentPositionVector.mult(alpha).add(previousPositionVector.mult(1-alpha));
		return {
			velocity: currentState.velocity, 
			acceleration : currentState.acceleration, 
			position: {
				x: blendedPositionVector.xComponent(),
				y: blendedPositionVector.yComponent()
			}
		};
	};

	Simulation.prototype.addToPlayingField = function( pointCharge ) {
		
		if ( this.charges.indexOf( pointCharge ) === -1 ) {
			this.charges.push( pointCharge );
		}
	};

	Simulation.prototype.removeFromPlayingField = function( pointCharge ) {
		var index = this.charges.indexOf( pointCharge );
		if ( index > -1 ) {
			this.charges.splice( index, 1 );
		}
	};

	EFH.Simulation = Simulation;;
})( typeof window === 'undefined' ? global : window);