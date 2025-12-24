import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/// Creates particle effects for score events
class ScoreParticleEffect extends Component {
  final Vector2 position;
  final Random _random = Random();

  ScoreParticleEffect({required this.position});

  @override
  Future<void> onLoad() async {
    // Create star particles
    final particles = List.generate(
      8,
      (i) {
        final angle = (i / 8) * 2 * pi;
        final speed = 50.0 + _random.nextDouble() * 50.0;

        return Particle.generate(
          count: 1,
          lifespan: 0.6,
          generator: (i) {
            return AcceleratedParticle(
              speed: Vector2(
                cos(angle) * speed,
                sin(angle) * speed,
              ),
              acceleration: Vector2(0, 200),
              child: CircleParticle(
                radius: 3.0 + _random.nextDouble() * 2.0,
                paint: Paint()
                  ..color = Color.lerp(
                    Colors.yellow,
                    Colors.orange,
                    _random.nextDouble(),
                  )!,
              ),
            );
          },
        );
      },
    );

    add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 1,
          generator: (i) => ComposedParticle(children: particles),
        ),
      ),
    );

    // Remove this component after particles are done
    Future.delayed(const Duration(milliseconds: 700), () {
      removeFromParent();
    });
  }
}

/// Creates collision particles
class CollisionParticleEffect extends Component {
  final Vector2 position;
  final Random _random = Random();

  CollisionParticleEffect({required this.position});

  @override
  Future<void> onLoad() async {
    // Create explosion particles
    final particles = List.generate(
      15,
      (i) {
        final angle = _random.nextDouble() * 2 * pi;
        final speed = 100.0 + _random.nextDouble() * 100.0;

        return Particle.generate(
          count: 1,
          lifespan: 0.8,
          generator: (i) {
            return AcceleratedParticle(
              speed: Vector2(
                cos(angle) * speed,
                sin(angle) * speed,
              ),
              acceleration: Vector2(0, 300),
              child: CircleParticle(
                radius: 4.0 + _random.nextDouble() * 3.0,
                paint: Paint()
                  ..color = Color.lerp(
                    Colors.red,
                    Colors.orange,
                    _random.nextDouble(),
                  )!,
              ),
            );
          },
        );
      },
    );

    add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 1,
          generator: (i) => ComposedParticle(children: particles),
        ),
      ),
    );

    // Remove this component after particles are done
    Future.delayed(const Duration(milliseconds: 900), () {
      removeFromParent();
    });
  }
}
