import 'package:mg_common_game/core/assets/asset_types.dart';

/// Spine 렌더링 활성화 플래그.
/// `--dart-define=SPINE_ENABLED=true` 로 빌드 시 활성화.
const kSpineEnabled = bool.fromEnvironment('SPINE_ENABLED', defaultValue: false);

// ── Red Bird ────────────────────────────────────────────────

const kRedBirdMeta = SpineAssetMeta(
  key: 'red_bird',
  path: 'spine/characters/red_bird',
  atlasPath: 'assets/spine/characters/red_bird/red_bird.atlas',
  skeletonPath: 'assets/spine/characters/red_bird/red_bird.json',
  animations: ['idle', 'flap', 'fall', 'hit'],
  defaultAnimation: 'idle',
  defaultMix: 0.15,
);

// ── Blue Bird ───────────────────────────────────────────────

const kBlueBirdMeta = SpineAssetMeta(
  key: 'blue_bird',
  path: 'spine/characters/blue_bird',
  atlasPath: 'assets/spine/characters/blue_bird/blue_bird.atlas',
  skeletonPath: 'assets/spine/characters/blue_bird/blue_bird.json',
  animations: ['idle', 'flap', 'fall', 'hit'],
  defaultAnimation: 'idle',
  defaultMix: 0.15,
);

// ── Gold Bird ───────────────────────────────────────────────

const kGoldBirdMeta = SpineAssetMeta(
  key: 'gold_bird',
  path: 'spine/characters/gold_bird',
  atlasPath: 'assets/spine/characters/gold_bird/gold_bird.atlas',
  skeletonPath: 'assets/spine/characters/gold_bird/gold_bird.json',
  animations: ['idle', 'flap', 'fall', 'hit'],
  defaultAnimation: 'idle',
  defaultMix: 0.15,
);
