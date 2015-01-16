library game;

import 'dart:html';
import 'dart:math' show Random;
import 'package:vector_math/vector_math.dart';

part 'game-entity.dart';
part 'player.dart';
part 'invader.dart';
part 'bullet.dart';

// Controller

class Game {
	Vector2 size;
	List<GameEntity> bodies = [];
	List<GameEntity> bodiesNew = [];
	Random shaker = new Random();
	int countKills = 0;
	DateTime lastBuildInvader = new DateTime.now();
	double invaderSpeed = 0.5;
	int invaderComing = 2000; //geht noch nicht
	Player player;
	CanvasRenderingContext2D ctx;

	Game(CanvasRenderingContext2D context, double width, double height) {
		ctx = context;
		size = new Vector2(width, height);
		player = new Player(
        			new Vector2(size.x / 2, size.y - 20),
        			new Vector2(10.0, 10.0),
        			new Vector2(0.0, 0.0)
        		);
		bodies.add(player);
		bodies.addAll(createInvaders());
	}

	List createInvaders() {
		List invaders = [];

		var rand = new Random();
		int a = rand.nextInt(240);
		double b = a.toDouble();

		for (var i = 0; i < 1; i++) {
			invaders.add( new Invader(
					new Vector2( (30.0 + b), (30.0)),
					new Vector2(15.0, 15.0),
					new Vector2(0.0, invaderSpeed)
			));
		}
		return invaders;
	}

	addBody(GameEntity body) {
		// add all bodies to temp array to not touch array during iteration
		bodiesNew.add(body);
	}

	update() {
		bodies = getNonCollidingBodies();

		bodies.forEach( (body) {
			body.update();
			if (body is Invader) {
				body.shoot = true;
				bodies.forEach( (b) {
					body.shoot = (body.shoot && ( !(b is Invader) || (!b.isBelow(body)) ));
				});
				if (body.shoot && (shaker.nextInt(1000) > 995) ) {
					addBody(new Bullet(
							body.center.clone().add(new Vector2(0.0, body.size.y/2 + 2)),
							new Vector2(3.0, 3.0),
							new Vector2(0.0, 2.0)
					));
				}
			}
			if (body is Player) {
				//do not go out of frame
				if (body.center.x < 0) {
					body.center.x = 0.0;
				}
				if (body.center.x > size.x) {
					body.center.x = size.x;
				}
				var timeNow = new DateTime.now();
				if (body.shoot && timeNow.difference(body.lastBulletTime).inMilliseconds > 200) {
					body.lastBulletTime = timeNow;
					var bullet = new Bullet(
							body.center.clone().add(new Vector2(0.0, -body.size.y/2 - 2)),
							new Vector2(3.0, 3.0),
							new Vector2(0.0, -6.0)
					);
					addBody(bullet);
				}
			}
		});

		// remove out canvas bodies
		bodies.removeWhere((b) => b.center.x < 0 || b.center.x > size.x || b.center.y < 0 || b.center.y > size.y);

		// now add all new bodies
		bodies.addAll(bodiesNew);
		bodiesNew = [];

		//was wenn unter 1000? und nincht sofort schneller werden
		//muesste eigentlich % 26 sein weil es bei eins anfängt sonst zaehlt er 24
		if ((countKills + 1) % 25 == 0) {
			if (invaderComing >= 1000) {
				invaderComing -= 100;
			}
		}

		//invaderComing statt 200 wenn es denn geht
		var timeNow = new DateTime.now();
		if (timeNow.difference(lastBuildInvader).inMilliseconds > invaderComing) {
			lastBuildInvader = timeNow;
			bodies.addAll(createInvaders());
		}
	}

	List getNonCollidingBodies() {
		var notCollidingBodies = [];
		for (var b1 in bodies) {
			if (b1 is Invader) {
				var notColliding = true;
				for (var b2 in bodies) {
					if (b1.isCollidingWith(b2)) {
						notColliding = false;
						countKills++;
						break;
					}
				}
			}

			var notColliding = true;
			for(var b2 in bodies) {
				if (b1.isCollidingWith(b2)) {
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



	draw() {
		ctx.clearRect(0, 0, size.x, size.y);
		bodies.forEach( (body) {
			ctx.fillRect(body.center.x - body.size.x / 2, body.center.y - body.size.y / 2,
					body.size.x, body.size.y);
		});

		ctx.fillText('Abgeschossene Gegner: ${countKills}', 5, 10);
	}
}