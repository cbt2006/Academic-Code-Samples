// placeholder for whether or not game is ongoing - controls various aspects of play
var gameActive = false;

function registerEvents() {
	for(var i = 0; i < 100; i++) {
		var box = document.getElementById("b" + i);
		if(box.addEventListener) {
			box.addEventListener("click", checkShip, false);
		} else if(box.attachEvent) {
			box.attachEvent("onclick", checkShip);
		} else {
			box.onclick="checkShip()";
		}
	}
}

function newGame() {
	// make game active
	gameActive = true;
	// reset all cells to starting state
	for(var i = 0; i < 100; i++) {
		var space = document.getElementById("b" + i);
		space.style.backgroundColor = "black";
		space.hit = "n";
		space.ship = "n";
	}
	
	var space; // placeholder for space on board
	// randomly select cell number to place submarine, but only continue if it doesn't already have a ship on it
	for(var i = 0; i < 10; i++) {
		do {
			var randSpace = Math.floor(Math.random() * 100);
			space = document.getElementById("b" + randSpace);
		} while(space.ship == "y");
		space.ship = "y";
}
	// set missile count and sonar count
	if(document.getElementById("lame").checked == true) {
		document.getElementById("missiles").innerHTML = "50";
		document.getElementById("sweeps").innerHTML = "Unlimited";
	} else if(document.getElementById("exp").checked == true) {
		document.getElementById("missiles").innerHTML = "25";
		document.getElementById("sweeps").innerHTML = "3";
	} else if(document.getElementById("adv").checked == true) {
		document.getElementById("missiles").innerHTML = "15";
		document.getElementById("sweeps").innerHTML = "1";
	}
	// disable mode buttons so we can't change mode in the middle of the game
	document.getElementById("lame").disabled = true;
	document.getElementById("exp").disabled = true;
	document.getElementById("adv").disabled = true;
	
	// ensure that sonar sweep and other useful buttons are enabled
	document.getElementById("sonar").disabled = false;
	document.getElementById("klingon").disabled = false;
	
	// enable End Game button
	document.getElementById("endgame").disabled = false;
}

// end the game, allow for new game to be started with different settings
function endGame() {
	gameActive = false; // make game inactive
	
	// re-enable settings
	document.getElementById("lame").disabled = false;
	document.getElementById("exp").disabled = false;
	document.getElementById("adv").disabled = false;
	
	// disable gameplay buttons
	document.getElementById("sonar").disabled = true;
	document.getElementById("klingon").disabled = true;
	
	// disable End Game button since game is already over
	document.getElementById("endgame").disabled = true;
}

// called when a box is clicked
function checkShip(event) {
	// if game is inactive (e.g. won, lost, or cancelled) then don't do anything
	if(gameActive == false) {
		return;
	}
	
	// code for IE
	if(!event) {
		event = window.event;
	}
	
	var source; // placeholder for clicked cell
	
	// Firefox/IE
	if(event.target) {
		source = event.target;
	} else if(event.srcElement) {
		source = event.srcElement;
	}

	// If there's a ship in the square, then make square red, mark as hit, and add missiles.
	// If space doesn't have a ship, it's a miss, so make square white, and subtract a missile.
	var missiles = document.getElementById("missiles"); // placeholders for missile count
	var missileCount = parseInt(missiles.innerHTML);
	
	if(source.ship == "y") {
		source.style.backgroundColor = "red";
		// give additional shots, but only if square hasn't already been hit
		if(source.hit == "n") {
			if(document.getElementById("lame").checked == true) {
				missileCount += 5;
			} else if(document.getElementById("exp").checked == true) {
				missileCount += 3;
			} else if(document.getElementById("adv").checked == true) {
				missileCount += 2;
			}
			missiles.innerHTML = missileCount;
		}
		source.hit = "y";
		checkGame(); // check if we've gotten all ships
	} else {
		source.style.backgroundColor = "white";
		// only subtract a missile if the cell hasn't been hit already
		if(source.hit == "n") {
			missileCount--;
			missiles.innerHTML = missileCount;
			// if missile count is zero, game over
			if(missileCount == 0) {
				alert("Sorry, you lose.  Game Over!");
				// add to lost games counter
				var loss = document.getElementById("lost");
				var lossNum = parseInt(loss.innerHTML);
				lossNum++;
				loss.innerHTML = lossNum;
				endGame(); // run game-ending functions
				return; // exit without doing anything else
			}
		}
		source.hit = "y";
	}
}

// alternate function used with Klingon bomb
function checkShip1(sourceBox) {
	// if there's a ship, make square red; if not, make square white
	if(sourceBox.ship == "y") {
		sourceBox.style.backgroundColor = "red";
		sourceBox.hit = "y";
	} else {
		sourceBox.style.backgroundColor = "white";
	}
}

// Klingon carpetbombing - hit 75 random targets
function klingonBomb() {
	
	// set up placeholders for possible targets
	var spaces = new Array(100);
	for(var i = 0; i < 100; i++) {
		spaces[i] = false;
	}
	
	// generate 75 random targets and make sure they're all different
	for(var i = 0; i < 75; i++) {
		var randSpace; // placeholder for random target
		do {
			randSpace = Math.floor(Math.random() * 100);
		} while(spaces[randSpace] == true);
		
		// fire at given space, then label that space as having been shot at so it isn't targeted again
		checkShip1(document.getElementById("b" + randSpace));
		spaces[i] = true;
	}
	// check if all ships have been hit
	if(checkGame()==true) {
		return;
	} else {
		alert("Sorry, you lose!  Game over.");
		// add to lost games counter
		var loss = document.getElementById("lost");
		var lossNum = parseInt(loss.innerHTML);
		lossNum++;
		loss.innerHTML = lossNum;

		endGame(); // run game-ending functions
	};
}

// calls fxn to reveal subs, then calls fxn to hide subs 1 second later
function toggleSonar() {
	sonarSweep();
	setTimeout('sonarHide()', 1000);
}

// reveal subs
function sonarSweep() {
	var sweeps = document.getElementById("sweeps");
	var sweepCount = sweeps.innerHTML;
	// only show sweep if there are sweeps left
	if(sweepCount > 0 || (document.getElementById("lame").checked == true)) {
		for(var i = 0; i < 100; i++) {
			var space = document.getElementById("b" + i);
			if(space.ship == "y" && space.hit == "n") {
				space.style.backgroundColor = "yellow";
			}
		}
		// count down sweeps, unless lame mode is checked
		if(document.getElementById("lame").checked == true) {
			// do nothing
		} else {
			sweepCount--;
			sweeps.innerHTML = sweepCount;
		}
		
		// if we're out of sweeps, disable the button so we can't click it again
		if(sweepCount == 0) {
			var sonarButton = document.getElementById("sonar");
			sonarButton.disabled = true;
		}
	}
}

// hide subs
function sonarHide() {
	for(var i = 0; i < 100; i++) {
		var space = document.getElementById("b" + i);
		if(space.ship == "y" && space.hit == "n") {
			space.style.backgroundColor = "black";
		}
	}
}

// check if game has been won (all subs hit)
function checkGame() {
	var counter = 0;
	for(var i = 0; i < 100; i++) {
		var space = document.getElementById("b" + i);
		if(space.hit == "y" && (space.style.backgroundColor == "red" || space.style.backgroundColor == "#ff0000")) {
			counter++;
		}
	}
	// if all 10 subs have been hit, alert that game is finished
	if(counter == 10) {
		alert("You win!");
		// add a win to score list
		var wins = document.getElementById("won");
		var numWins = parseInt(wins.innerHTML);
		numWins++;
		wins.innerHTML = numWins;
		
		endGame();  // run endGame() to disable game functionality
		return true; // for klingon bomb function, so we know the user won
	} else {
		return false; // didn't win
	}
}