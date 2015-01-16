part of game;

class Player extends GameEntity {
	DateTime lastBulletTime = new DateTime.now();
	double maxVelocity = 2.5;
	bool moveLeft = false;
	bool moveRight = false;
	bool shoot = false;

	Player(Vector2 center, Vector2 size, Vector2 velocity) : super(center, size, velocity) {}

	update() {
		if (moveLeft) {
			center.x -= maxVelocity;
		}
		if (moveRight) {
			center.x += maxVelocity;
		}
	}
}