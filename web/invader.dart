part of game;

class Invader extends GameEntity {
  double patrolX = 0.0;

  Invader(Game game, Vector2 center, Vector2 size, Vector2 velocity) : super(game, center, size, velocity) {}

  update() {
    if (this.patrolX < 0 || this.patrolX > 30) {
      velocity.x *= -1;
    }
    center.add(velocity);
    patrolX += this.velocity.x;

    if (game.shaker.nextInt(1000) > 995 && !game.areAnyInvadersBelow(this)) {
      game.addBody(new Bullet(
        game,
        center.clone().add(new Vector2(0.0, size.y/2 + 2)),
        new Vector2(3.0, 3.0),
        new Vector2(0.0, 2.0)
      ));
    }
  }

}
