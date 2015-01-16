part of game;

class Invader extends GameEntity {
	double patrolX = 0.0;
	bool shoot = false;
	bool ClearShootingPath = true;

	Invader(Vector2 center, Vector2 size, Vector2 velocity) : super(center, size, velocity) {}

	update() {
		if (this.patrolX < 0 || this.patrolX > 30) {
			velocity.x *= -1;
		}
		center.add(velocity);
		patrolX += this.velocity.x;
	}

	bool isBelow(Invader inv) {
		// X-check?
		return ((this.center.y > inv.center.y));
	}
}
