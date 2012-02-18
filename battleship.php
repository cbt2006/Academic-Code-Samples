<html>
	<head>
		<title>Battleship Game</title>
		<style type="text/css">
			body {
				width: 1024px;
			}
			p, h3, h1, h4 {
				text-align: center;
			}
			p {
				margin-top: 10px;
			}
			h3, h4 {
				margin-bottom: 0;
				margin-top: 0;
			}
			table {
				border: 1px solid black;
				margin-left: auto;
				margin-right: auto;
				text-align: center;
			}
			td {
				border: 1px solid black;
				width: 30px;
				height: 40px;
				text-align: center;
				background-color: black;
			}
		</style>
		<script type="text/javascript" src="battleship.js"></script>
	</head>
	<body onload="registerEvents()">
		<h1>Battleship!</h1>
		<p>The grid is 10 by 10.  Click squares to aim for ships.  Black squares have not been attacked.  White squares are misses;
		red squares are hits.  The sonar sweep reveals all enemy submarines for 1 second.  The Klingon death ray attacks 25%
		of the board at random.</p>
		<h3>Please choose your game type:</h3>
		<p>
			<input type="radio" name="mode" id="lame" value="lame" checked="checked" /> Lame Mode: 50 Missiles plus 5 extra for each hit. Unlimited sonar sweeps. <br />
			<input type="radio" name="mode" id="exp" value="exp" /> Experienced Mode: 25 Missiles plus 3 extra for each hit. Three available sonar sweeps. <br />
			<input type="radio" name="mode" id="adv" value="adv" /> Advanced Mode: 15 Missiles plus 2 extra for each hit. Only one sonar sweep allowed. <br />
			<input type="button" name="newgame" id="newgame" value="New Game" onclick="newGame()" />
			<input type="button" name="endgame" id="endgame" value="End Game" onclick="endGame()" />
		</p>
		<center>
		<table>
			<script type="text/javascript">
				// outputs Battleship grid - 10x10
				document.write("<tr>");
				for(var i = 0; i < 100; i++) {
					document.write("<td id='b" + i + "'>&nbsp;</td>");
					if((i + 1) % 10 == 0) {
						document.write("</tr><tr>");
					}
				}
				document.write("</tr>");
			</script>
		</table>
		</center>
		<br />
		<h3>Missiles Remaining: <span id="missiles" name="missiles"></span></h3>
		<h3>Sonar Sweeps Remaining: <span id="sweeps" name="sweeps"></span></h3>
		<p>
			<input type="button" name="sonar" id="sonar" value="Sonar Sweep" onclick="toggleSonar()" />
			<input type="button" name="klingon" id="klingon" value="Klingon Death Ray" onclick="klingonBomb()" /><br />
		</p>
		<h3>Score:</h3>
		<h4>Games Won: <span id="won" name="won">0</span><br /></h4>
		<h4>Games Lost: <span id="lost" name="lost">0</span><br /></h4>
	</body>
</html>