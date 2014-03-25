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
;var Assets = {
  images : {
  }
};
var loadAssets = (function() {
  var assetsList = [
    {
      name: "puck",
      source: '/img/puck.png',
      type: 'image'
    },
    {
      name: "positive",
      source: '/img/positive.png',
      type: 'image'
    },
    {
      name: "negative",
      source: '/img/negative.png',
      type: 'image'
    }
  ];

  var loadedAssetsCount = 0;
  var assetLoaded = function( asset, object, callback) {
    loadedAssetsCount++;

    if ( asset.type === 'image' ) {
      Assets.images[asset.name] = object;
    }

    if ( loadedAssetsCount === assetsList.length ) {
      callback();
    }
  };

  return function( options, cb ) {
    var opt = options || {};
    var rootDir = opt.rootDir || '';

    assetsList.forEach(function( asset ) {
      if (asset.type === 'image') {
        var img = new Image();
        img.onload = function() {
          assetLoaded(asset, img, cb);
        };
        img.src = rootDir + asset.source;
      }
    });
  };
})();
;  var Puck = function(x, y) {
    this.charge = new EFH.PointCharge({x: x, y: y, charge: 1});
    this.velocity = EFH.Vector.ZERO;
    this.shape = new Kinetic.Image({
      x : x - 20,
      y : y - 20,
      image : Assets.images.puck
    });
  };

  Puck.prototype.moveTo = function(x, y) {
    this.charge.x = x;
    this.charge.y = y;
    this.shape.setPosition(x - 20, y - 20);
  };

  Puck.prototype.getX = function() {
    return this.charge.x;
  };

  Puck.prototype.getY = function() {
    return this.charge.y;
  };

  Puck.prototype.getRadius = function() {
    return 20;
  };
;var DRAGCHARGE_RADIUS = 20;
/**
 * Represents a draggable charge on the screen. Basically wraps Kinetic.Image
 * and EFH.PointCharge so that they can be kept in sync
 * @param  {Number} x           x position of DragCharge
 * @param  {Number} y           y position of DragCharge
 * @param  {Number} chargeValue Value of charge (usually 1.0)
 * @return {DragCharge}
 */
var DragCharge = function(x, y, chargeValue) {
  var self = this;
  var charge = new EFH.PointCharge({x:x, y:y, charge: chargeValue});
  var shape = new Kinetic.Image({
    x: x - DRAGCHARGE_RADIUS,
    y: y - DRAGCHARGE_RADIUS,
    image : chargeValue >= 0 ? Assets.images.positive : Assets.images.negative,
    draggable: true,
    name: "draggablepoint"
  });

  /* Tells Kinetic that the transparent pixels are not hittable */
  shape.createImageHitRegion();

  shape.on("dragend", function() {
    /**
     * Since the PointCharge x and y are the center of the charge, but
     * the Kinetic.Image x and y are the upper left corner, we need to
     * translate the point
     */
    charge.x = this.getX() + DRAGCHARGE_RADIUS;
    charge.y = this.getY() + DRAGCHARGE_RADIUS;

    if ( typeof(self.onDragEnd) === 'function' ) {
      self.onDragEnd();
    }
  });

  shape.on("mousedown touchstart", function() {
    shape.moveToTop();
  });

  this.charge = charge;
  this.shape = shape;
};

/**
 * Gets the x coordinate of the center of the charge. Use for physics and
 * not for display.
 * @return {Number} x coordinate
 */
DragCharge.prototype.getX = function() {
  return this.charge.x;
};

/**
 * Gets the y coordinate of the center of the charge. Use for physics and
 * not for display.
 * @return {Number} y coordinate
 */
DragCharge.prototype.getY = function() {
  return this.charge.y;
};

/**
 * Gets the radius of the DragCharge
 * @return {Number} Radius in pixels
 */
DragCharge.prototype.getRadius = function() {
  return DRAGCHARGE_RADIUS;
};
;/**
 * Represents a Map or Level - the configuration of a puzzle the user must solve
 * @return {Level}
 */
var Level = function() {

  /**
   * Set a bunch of defaults
   */
  this.name = 'Level';
  this.goal = {
    x: 0,
    y: 0,
    width: 25,
    height: 100
  };
  this.background = { url : null, image : null };
  this.puckPosition = { x : 0, y: 0 };
  this.startingCharges = [1,-1,1,-1,1,-1];
  this.width = 0;
  this.height = 0;
};

/**
 * Load from a source, calling back when all the level assets are downloaded
 * @param  {Object}   source   The level data
 * @param  {Function} callback Called when all assets are loaded
 */
Level.load = function( source, callback ) {
  if ( typeof source === 'string' ) {
    Level.loadJson( source, callback );
  } else {
    Level.loadObject( source, callback );
  }
};

Level.loadObject = function( source, callback ) {
  var map = new Level();
  merge(map, source);

  map.height = +map.height;
  map.width = +map.width;
  map.goal.x = +map.goal.x;
  map.goal.y = +map.goal.y;
  map.goal.width = +map.goal.width;
  map.goal.height = +map.goal.height;
  map.puckPosition.x = +map.puckPosition.x;
  map.puckPosition.y = +map.puckPosition.y;
  if ( typeof source.startingCharges === 'string' ) {
    map.startingCharges = source.startingCharges.split(',').map(function(c) {
      return +c;
    });
  }

  if ( source.backgroundUrl ) {
    map.background.url = source.backgroundUrl;
    map.background.image = new Image();
    map.background.image.onload = function() {
      callback( map );
    };

    map.background.image.src = map.background.url;
  } else {
    callback( map );
  }
};

Level.loadJson = function( source, callback ) {
  throw "NOT IMPLEMENTED";
};
;/**
 * The Electric Field Hockey game class. Handles all interactions and display
 * rendering.
 * @param  {Object}  options  options object
 * @return {Game}
 */
var Game = function( options ) {

  __setBlanks( this );
  this.options = {
    container : "efh-simulation",
    debug: false
  };

  merge(this.options, options);
};

var __setBlanks = function( thisObj ) {
  thisObj.stage = null; //Kinetic.Stage - canvas where rendering takes place
  thisObj.layer = null; //Kinetic.Layer - container for all interaction objects
  thisObj.puckLayer = null;
  thisObj.anim = null;  //Kinetic.Animation - animation class
  thisObj.puck = null;  //EFH.Puck - represents the moving hockey puck
  thisObj.map = null;   //EFH.Level - a game configuration
  thisObj.txt = null;   //Kinetic.Text - output for debugging
  thisObj.events = {
    "lose" : [],
    "win" : [],
    "stop" : [],
    "start" : []
  };
  thisObj.goal = null;
  thisObj.dragCharges = [];
};

/**
 * Inits the Game by loading from a Level configuration
 * @param  {object}  mapSource   Level
 * @return {chain}
 */
Game.prototype.init = function( mapSource ) {
  var self = this;

  if (self.stage) {
    self.destroy();
  }

  /**
   * Load the level and its assets, and when complete, start configuring the
   * environment
   */
  Level.load( mapSource, function(map) {

    self.stage = new Kinetic.Stage( {
      width: map.width + 100,
      height: map.height,
      container: self.options.container
    });

    self.layer = new Kinetic.Layer();
    self.puckLayer = new Kinetic.Layer();

    self.puck = new Puck(100+map.puckPosition.x, map.puckPosition.y);
    self.puckLayer.add( self.puck.shape );

    self.goal = new Kinetic.Rect({
      x: map.goal.x + 100,
      y: map.goal.y,
      width: map.goal.width,
      height: map.goal.height,
      fill: 'green'
    });
    self.layer.add( self.goal );

    self.txt = new Kinetic.Text({
      x: self.stage.getWidth() - 200,
      y: 15,
      text: '',
      fontSize: 10,
      fontFamily: 'Calibri',
      fill: 'green'
    });
    self.layer.add( self.txt );

    var bx = 100,
      by = 0,
      bw = map.width,
      bh = map.height;
    var border = new Kinetic.Line({
      points: [bx, by, bx + bw, by, bx + bw, by + bh, bx, by + bh, bx, by],
      stroke: 'black',
      strokeWidth: 2
    });
    self.layer.add( border );

    self.addInitialCharges(map.startingCharges);

    /* Load background image */
    if (map.background.image) {
      var bg = new Kinetic.Image({
        image: map.background.image,
        x: bx, y: by,
        width: bw, height: bh
      });

      self.layer.add( bg );
      bg.moveToBottom();

      bg.createImageHitRegion(function() {
        self.layer.draw();
      });
    }

    self.map = map;

    self.stage.add( self.layer );
    self.stage.add( self.puckLayer );
    self.anim = self.createAnimation();

    self.layer.draw();
    self.puckLayer.draw();

    self.reset();
  });

  return self;
};

/**
 * Writes some debugging text to the canvas
 * @param  {String} text debugging text to write
 */
Game.prototype.debug = function(text) {
  if (this.options.debug) {
    this.txt.setText(text);
  }
};

/**
 * Checks if a puck position and radius would cause a collision
 * 
 * @param  {Number} x      x coordinate of puck
 * @param  {Number} y      y coordinate of puck
 * @param  {Number} radius radius of puck
 * @return {Object|false}        Object that would be hit or false if no hit
 */
Game.prototype.isCollision = function(x, y, radius) {

  /**
   * Using the x and y as the center, check a number of points around the
   * permiter of the circle for a possible collision
   */
  var pointsToCheck = 8; //test this many points along the perimeter
  var angle = 0;         //initial angle
  var r = radius + 0;    //plus buffer so it doesnt collide with itself
  for ( var i = 0; i < pointsToCheck; i++) {

    /* Calculate perimeter x and y */
    var px = x + r * Math.cos(angle);
    var py = y + r * Math.sin(angle);

    /* test for object occupying that point */
    var obj = this.layer.getIntersection(px, py);

    /* Make sure theres something there, that its a shape, and that it is
     * not the puck (shouldnt report colliding with itself)
     */
    if (obj && obj.shape && obj.shape !== this.puck.shape) {
      return obj.shape;
    }

    /* Calculate the next point along the perimeter */
    angle += (2*Math.PI) / pointsToCheck;
  }

  return false;
};

/**
 * Check the state of the simulation for indicators that the game is ended
 *
 * @param  {Object} state simulation state
 * @param  {Object} frame current frame data
 */
Game.prototype.checkState = function( state, frame ) {

  if (!this.anim || !this.anim.isRunning()) {
    return;
  }

  /* Test for collision with another object */
  var object = this.isCollision(state.position.x, state.position.y, this.puck.getRadius());
  if ( object ) {
    this.render( state, frame.frameRate );
    this.handleCollision( object );
    return;
  }

  /* test if object got off the screen */
  if (this.isOffScreen(state.position.x, state.position.y)) {
    this.handleCollision( "screen" );
  }
};

/**
 * Check if a point is outside the bounds of the simulation
 * @param  {Number}  x x-coordinate
 * @param  {Number}  y y-coordinate
 * @return {Boolean}   true if off screen
 */
Game.prototype.isOffScreen = function(x, y) {
  return (x > 100 + this.map.width) ||
    (x < 100) ||
    (y > this.map.height) ||
    (y < 0);
};

/**
 * Creates the Kinetic.Animation object that will control
 * the frame rate and drawing
 * @return {Kinetic.Animation}
 */
Game.prototype.createAnimation = function() {
  var self = this;
  var currentState = {
    position: {x: self.puck.getX(), y: self.puck.getY() },
    velocity: self.puck.velocity,
    acceleration: EFH.Vector.ZERO,
    charge : self.puck.charge
  };

  var simulation = new EFH.Simulation( currentState, function( state, frame ) {
    /*
     * This callback is called for each step of the simulation, which
     * may not be the same as each frame
     */
    self.checkState( state, frame );
  });

  var a =  new Kinetic.Animation(function(frame) {
    if (frame.timeDiff === 0){
      return;
    }

    /*
     * Calculate the state for right now. Doing so may involve more than one
     * step in the simulation. Checking the state of the simulation for out
     * of bounds, collisions, end of game, etc is done in the callback 
     * configured for the EFH.Simulation constructor
     */
    var state = simulation.handleFrameRequest( frame );

    self.render( state, frame.frameRate );

  }, self.layer);

  /* Attach the simulation object on so we can access it later */
  a.simulation = simulation;

  return a;
};

/**
 * Convert a simulation state into something we can move about on the screen
 * @param  {Object} state Simulation state
 * @param  {Number} fps   frames per second
 */
Game.prototype.render = function( state, fps ) {
  this.puck.velocity = state.velocity;
  this.puck.moveTo( state.position.x, state.position.y );
  this.puckLayer.draw();
  this.debug("FPS: " + fps);
};

/**
 * Handles a collision with a shape. Stops the simulation and figures out if you
 * won or not
 * @param  {Object} shape The shape with which the puck collided
 */
Game.prototype.handleCollision = function( shape ) {
  this.stop();
  if (shape !== false) {
    if (shape == this.goal) {
      this.fire('win');
    } else {
      this.fire('lose');
    }
  } else {
    this.fire('lose');
  }
};

/**
 * Adds the initial charges that are available for the user to play with
 * @param  {Array} initialCharges array of charge values
 */
Game.prototype.addInitialCharges = function( initialCharges ) {
  var x = 25, y = 25;
  for (var i = 0; i < initialCharges.length; i++) {
    this.addCharge(x, y, initialCharges[i]);
    y+=20;
  }
};

/**
 * Start the animation
 */
Game.prototype.start = function() {
  this.fire('start');
  this.dragCharges.forEach(function(dc) {
    dc.shape.setDraggable(false);
  });
  this.anim.start();
};

/**
 * Stop the animation
 */
Game.prototype.stop = function() {
  this.fire('stop');
  this.dragCharges.forEach(function(dc) {
    dc.shape.setDraggable(true);
  });
  this.anim.stop();
};

/**
 * Toggles the animation state
 * @return {Boolean} true if the simulation is running after the toggle
 */
Game.prototype.toggle = function() {
  if(this.anim.isRunning()) {
    this.stop();
    return false;
  } else {
    this.start();
    return true;
  }
};

/**
 * Adds a charge to the game
 * @param  {Number} x      x-coordinate
 * @param  {Number} y      y-coordinate
 * @param  {Number} charge charge value
 */
Game.prototype.addCharge = function(x, y, charge) {
  var dragCharge = new DragCharge(x, y, charge);
  this.layer.add(dragCharge.shape);
  this.layer.draw();

  var self = this;

  /**
   * Set up callbacks so we can add or remove the charge from the 
   * simulation
   */
  dragCharge.onDragEnd = function() {
    if (! self.isOffScreen(this.getX(), this.getY())) {
      self.anim.simulation.addToPlayingField(this.charge);
    } else {
      self.anim.simulation.removeFromPlayingField(this.charge);
    }
  };

  this.dragCharges.push( dragCharge );
  return dragCharge;
};

/**
 * Resets the game: moves the puck back to the starting point but does not
 * remove any charges placed by the user
 */
Game.prototype.reset = function() {
  this.puck.moveTo(100 + this.map.puckPosition.x, this.map.puckPosition.y);
  this.puck.velocity = EFH.Vector.ZERO;
  this.anim.simulation.reset();
  this.layer.draw();
  this.puckLayer.draw();
};

/**
 * Saves the game state to JSON
 */
Game.prototype.serialize = function() {
  return this.anim.simulation.serialize();
};

Game.prototype.deserialize = function(json) {
  var obj = JSON.parse(json);
  var self = this;
  obj.charges.forEach(function(c) {
    var dc = self.addCharge(c.x, c.y, c.charge);
    self.anim.simulation.addToPlayingField(dc.charge);
  });
};

Game.prototype.on = function( event, callback ) {
  if (this.events.hasOwnProperty(event)) {
    this.events[event].push(callback);
    return true;
  }

  return false;
};

Game.prototype.fire = function( event ) {
  if (this.events.hasOwnProperty(event)) {
    var callbacks = this.events[event];
    for( var i = 0; i < callbacks.length; i++) {
      callbacks[i].call(this);
    }
  }
};

var createGame = function( options, callback ) {
  loadAssets(options, function() {
    var g = new Game(options);
    callback( g );
  });
};

Game.prototype.destroy = function() {
  this.stage.destroy();
  this.stage.destroyChildren();
  __setBlanks( this );
};

EFH.createGame = createGame;
;
})( typeof window === 'undefined' ? global : window);;(function(window) {
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

EFH.Vector = Vector;
;var K = 1000000; //force constant

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
EFH.K = K;
;/**
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
;  var Simulation = function(initialState, onStep) {
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

  Simulation.prototype.serialize = function() {
    return JSON.stringify({
      charges: this.charges
    });
  };

  EFH.Simulation = Simulation;
;
})( typeof window === 'undefined' ? global : window);