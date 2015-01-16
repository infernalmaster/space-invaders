import 'game.dart';
import 'dart:html';


Set keyState = new Set();
Map KEYS = { 'LEFT': 37, 'RIGHT': 39, 'S': 32 };
Game game;
final CanvasElement canvas = querySelector("#game");
final CanvasRenderingContext2D ctx = canvas.context2D;

void main() {
	game = new Game(ctx, canvas.width.toDouble(), canvas.height.toDouble());
	_tick(0);
	window.onKeyDown.listen(_onKeyDown);
	window.onKeyUp.listen(_onKeyUp);
}

_tick(num highResTime) {
	game.update();
	game.draw();
	window.requestAnimationFrame(_tick);
}

_onKeyDown(KeyboardEvent e) {
	keyState.add(e.keyCode);
	game.player.moveLeft = (keyState.contains(KEYS['LEFT']));
	game.player.moveRight = (keyState.contains(KEYS['RIGHT']));
	game.player.shoot = (keyState.contains(KEYS['S']));
}

_onKeyUp(KeyboardEvent e) {
	keyState.remove(e.keyCode);
	game.player.moveLeft = (keyState.contains(KEYS['LEFT']));
	game.player.moveRight = (keyState.contains(KEYS['RIGHT']));
	game.player.shoot = (keyState.contains(KEYS['S']));
}
