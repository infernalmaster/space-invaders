part of game;

class GameEntity {
  Game game;
  Vector2 size;
  Vector2 center;
  Vector2 velocity;

  GameEntity(Game this.game, Vector2 this.center, Vector2 this.size, Vector2 this.velocity) {}

  update() {
    center.add(velocity);
  }

}
