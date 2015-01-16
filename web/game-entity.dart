part of game;

class GameEntity {
	Vector2 size;
	Vector2 center;
	Vector2 velocity;

	GameEntity(Vector2 this.center, Vector2 this.size, Vector2 this.velocity) {}

	update() {
		center.add(velocity);
	}

	bool isCollidingWith(GameEntity e) {
		return !(
			this == e ||
			this.center.x + this.size.x / 2 < e.center.x - e.size.x / 2 ||
			this.center.y + this.size.y / 2 < e.center.y - e.size.y / 2 ||
			this.center.x - this.size.x / 2 > e.center.x + e.size.x / 2 ||
			this.center.y - this.size.y / 2 > e.center.y + e.size.y / 2
		);
	}
}