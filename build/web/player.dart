part of game;

class Player extends GameEntity {
  DateTime lastBulletTime = new DateTime.now();
  double maxVelocity = 2.0;

  Player(Game game, Vector2 center, Vector2 size, Vector2 velocity) : super(game, center, size, velocity) {}

  update() {
    // do not go out of frame
    if (center.x - maxVelocity < 0) {
      center.x = maxVelocity;
    } else if (center.x + maxVelocity > game.size.x) {
      center.x = game.size.x - maxVelocity;
    }

    if (game.keyboarder.isDownByName('LEFT')) {
      center.x -= maxVelocity;
    }
    if (game.keyboarder.isDownByName('RIGHT')) {
      center.x += maxVelocity;
    }

    var timeNow = new DateTime.now();
    if (game.keyboarder.isDownByName('S') && timeNow.difference(lastBulletTime).inMilliseconds > 100) {
      lastBulletTime = timeNow;
      var bullet = new Bullet(
        game,
        center.clone().add(new Vector2(0.0, -size.y/2 - 2)),
        new Vector2(3.0, 3.0),
        new Vector2(0.0, -7.0)
      );
      game.addBody(bullet);
    }
  }

}
