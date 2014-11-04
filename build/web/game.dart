library game;

import 'package:vector_math/vector_math.dart';
import 'dart:html';
import 'dart:math' show Random;

part 'keyboarder.dart';
part 'game-entity.dart';
part 'player.dart';
part 'invader.dart';
part 'bullet.dart';

class Game {
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  Vector2 size;
  List<GameEntity> bodies = [];
  List<GameEntity> bodiesNew = [];
  Keyboarder keyboarder = new Keyboarder();
  Random shaker = new Random();

  Game() {
    canvas = querySelector("#game");
    ctx = canvas.context2D;
    size = new Vector2(canvas.width.toDouble(), canvas.height.toDouble());

    bodies.add(new Player(this,
        new Vector2(size.x / 2, size.y - 20),
        new Vector2(10.0, 10.0),
        new Vector2(0.0, 0.0)
    ));
    bodies.addAll(createInvaders());

    _tick(0);
  }

  List createInvaders(){
    List invaders = [];

    for (var i = 0; i < 24; i++) {
      invaders.add( new Invader(this,
        new Vector2( (30 + (i % 8) * 30).toDouble(), (30 + (i % 3) * 30).toDouble()),
        new Vector2(15.0, 15.0),
        new Vector2(0.3, 0.0)
      ));
    }
    return invaders;
  }

  bool areAnyInvadersBelow(invader) {
    bool isBelow = false;
    bodies.forEach( (body) {
      if (
          body is Invader &&
          body != invader &&
          body.center.y > invader.center.y) {
        isBelow = true;
        return;
      }
    });
    return isBelow;
  }

  addBody(GameEntity body) {
    // add all bodies to temp array to not touch array during iteration
    bodiesNew.add(body);
  }

  _tick(num highResTime) {
    update();
    draw();
    window.requestAnimationFrame(_tick);
  }

  update() {

    // remove out canvas bodies
    bodies.removeWhere((b) => b.center.x < 0 || b.center.x > size.x ||
                              b.center.y < 0 || b.center.y > size.y);

    bodies = getNonCollidingBodies();

    bodies.forEach( (body) {
      body.update();
    });

    // now add all new bodies
    bodies.addAll(bodiesNew);
    bodiesNew = [];
  }

  draw() {
    ctx.clearRect(0, 0, size.x, size.y);

    bodies.forEach( (body) {
      ctx.fillRect(body.center.x - body.size.x / 2, body.center.y - body.size.y / 2,
                   body.size.x, body.size.y);
    });

    ctx.fillText('bodeis in game: ${bodies.length}', 5, 10);
  }

  List getNonCollidingBodies() {
    var notCollidingBodies = [];
    for (var b1 in bodies) {
      var notColliding = true;
      for(var b2 in bodies) {
        if (isColliding(b1, b2)) {
          notColliding = false;
          break;
        }
      }
      if (notColliding) {
        notCollidingBodies.add(b1);
      }
    }
    return notCollidingBodies;
  }

  bool isColliding(b1, b2) {
    return !(
      b1 == b2 ||
      b1.center.x + b1.size.x / 2 < b2.center.x - b2.size.x / 2 ||
      b1.center.y + b1.size.y / 2 < b2.center.y - b2.size.y / 2 ||
      b1.center.x - b1.size.x / 2 > b2.center.x + b2.size.x / 2 ||
      b1.center.y - b1.size.y / 2 > b2.center.y + b2.size.y / 2
    );
  }

}
