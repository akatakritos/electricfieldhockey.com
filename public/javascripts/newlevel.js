$(document).ready(function() {
  var sim,
      currGameData;

  var setStep = function(step) {
    for(var i = 1; i <= 3; i++) {
      if (step === i) {
        $('.step-'+i).show();
        $('.step-'+i+'-active').addClass('active');
      } else {
        $('.step-'+i).hide();
        $('.step-'+i+'-active').removeClass('active');
      }
    }
  };

  var editor = new EFH.LevelEditor('editor', {
    width: 800,
    height: 450
  });

  $('#draw').click(function(e) {
    e.preventDefault();
    editor.draw();
    setStep(1);
    $('#editor').show();
    $('#game').hide();
  });

  $('#editgoal').click(function(e) {
    e.preventDefault();
    editor.editGoal();
    setStep(2);
    $('#editor').show();
    $('#game').hide();
  });

  $('#test').click(function(e) {
    e.preventDefault();
      var gameData = editor.getData();
      gameData.fixedCharges = [];

      var positives = $('#positives').val();
      var negatives = $('#negatives').val();
      gameData.startingCharges = [];

      for (var i = 0; i < positives; i++) {
        gameData.startingCharges.push(1);
        }

        for (var i = 0; i < negatives; i++) {
        gameData.startingCharges.push(-1);
        }

      sim.init(gameData);
      currGameData = gameData;
      $('#editor').hide();
      $('#game').show();
      setStep(3);
  });



  EFH.createGame({container: 'game'}, function(game) {
    sim = game;

    sim.on('start', function() {
      $('#game-toggle').text('Stop');
    });

    sim.on('stop', function() {
      $('#game-toggle').text('Start');
    });

  });

  setStep(1);
  $('#game').hide();

  $('#game-toggle').click(function(e) {
    e.preventDefault();

    if ($(this).text() == 'Start') {
      sim.reset();
    }
    sim.toggle();
  });

  $('#game-reset').click(function(e) {
    e.preventDefault();
    sim.reset();
  });

  $('#create').click(function(e) {
    e.preventDefault();

    if (! $('#level_name').val()) {

      $('#level_name').focus().parent().addClass('error');

      return;
    }
    var levelData = currGameData;
    var post = {
      level: {
        name: $('#level_name').val(),
        json: levelData
      }
    };

    $('#create').attr('disabled', 'disabled').text('Saving...');

    var resetButton = function() {
      $('#create').removeAttr('disabled').text('Save');
    };

    $.ajax({
      type: 'POST',
      url: '/levels', 
      data: JSON.stringify(post),
      contentType:"application/json; charset=utf-8",
      dataType: 'json'}).success(function(d) {
        window.location = '/levels/' + d.level.id;
    }).always(resetButton);
  });



});
