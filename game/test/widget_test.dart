import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:game/main.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    GetIt.I.reset();
    GetIt.I.registerSingleton<AudioManager>(AudioManager());
  });

  testWidgets('Flappy Bird smoke test', (WidgetTester tester) async {
    // Set a realistic screen size to avoid overflow errors
    await tester.binding.setSurfaceSize(const Size(800, 800));

    await tester.pumpWidget(const FlappyBirdApp());
    await tester.pumpAndSettle();
    expect(find.text('FLAPPY'), findsOneWidget);
    expect(find.text('BIRD'), findsOneWidget);
  });
}
