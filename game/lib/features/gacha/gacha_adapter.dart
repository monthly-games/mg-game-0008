/// 가챠 시스템 어댑터 - MG-0008 Flappy Adventure
library;

import 'package:flutter/foundation.dart';
import 'package:mg_common_game/systems/gacha/gacha_pool.dart';
import 'package:mg_common_game/systems/gacha/gacha_manager.dart';

/// 게임 내 Bird 모델
class Bird {
  final String id;
  final String name;
  final GachaRarity rarity;
  final Map<String, dynamic> stats;

  const Bird({
    required this.id,
    required this.name,
    required this.rarity,
    this.stats = const {},
  });
}

/// Flappy Adventure 가챠 어댑터
class BirdGachaAdapter extends ChangeNotifier {
  final GachaManager _gachaManager = GachaManager(
    pityConfig: const PityConfig(
      softPityStart: 70,
      hardPity: 80,
      softPityBonus: 6.0,
    ),
    multiPullGuarantee: const MultiPullGuarantee(
      minRarity: GachaRarity.rare,
    ),
  );

  static const String _poolId = 'flappy_pool';

  BirdGachaAdapter() {
    _initPool();
  }

  void _initPool() {
    final pool = GachaPool(
      id: _poolId,
      nameKr: 'Flappy Adventure 가챠',
      items: _generateItems(),
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 365)),
    );
    _gachaManager.registerPool(pool);
  }

  List<GachaItem> _generateItems() {
    return [
      // UR (0.6%)
      GachaItem(id: 'ur_flappy_001', nameKr: '전설의 Bird', rarity: GachaRarity.ultraRare),
      GachaItem(id: 'ur_flappy_002', nameKr: '신화의 Bird', rarity: GachaRarity.ultraRare),
      // SSR (2.4%)
      GachaItem(id: 'ssr_flappy_001', nameKr: '영웅의 Bird', rarity: GachaRarity.superRare),
      GachaItem(id: 'ssr_flappy_002', nameKr: '고대의 Bird', rarity: GachaRarity.superRare),
      GachaItem(id: 'ssr_flappy_003', nameKr: '황금의 Bird', rarity: GachaRarity.superRare),
      // SR (12%)
      GachaItem(id: 'sr_flappy_001', nameKr: '희귀한 Bird A', rarity: GachaRarity.superRare),
      GachaItem(id: 'sr_flappy_002', nameKr: '희귀한 Bird B', rarity: GachaRarity.superRare),
      GachaItem(id: 'sr_flappy_003', nameKr: '희귀한 Bird C', rarity: GachaRarity.superRare),
      GachaItem(id: 'sr_flappy_004', nameKr: '희귀한 Bird D', rarity: GachaRarity.superRare),
      // R (35%)
      GachaItem(id: 'r_flappy_001', nameKr: '우수한 Bird A', rarity: GachaRarity.rare),
      GachaItem(id: 'r_flappy_002', nameKr: '우수한 Bird B', rarity: GachaRarity.rare),
      GachaItem(id: 'r_flappy_003', nameKr: '우수한 Bird C', rarity: GachaRarity.rare),
      GachaItem(id: 'r_flappy_004', nameKr: '우수한 Bird D', rarity: GachaRarity.rare),
      GachaItem(id: 'r_flappy_005', nameKr: '우수한 Bird E', rarity: GachaRarity.rare),
      // N (50%)
      GachaItem(id: 'n_flappy_001', nameKr: '일반 Bird A', rarity: GachaRarity.normal),
      GachaItem(id: 'n_flappy_002', nameKr: '일반 Bird B', rarity: GachaRarity.normal),
      GachaItem(id: 'n_flappy_003', nameKr: '일반 Bird C', rarity: GachaRarity.normal),
      GachaItem(id: 'n_flappy_004', nameKr: '일반 Bird D', rarity: GachaRarity.normal),
      GachaItem(id: 'n_flappy_005', nameKr: '일반 Bird E', rarity: GachaRarity.normal),
      GachaItem(id: 'n_flappy_006', nameKr: '일반 Bird F', rarity: GachaRarity.normal),
    ];
  }

  /// 단일 뽑기
  Bird? pullSingle() {
    final result = _gachaManager.pull(_poolId);
    if (result == null) return null;
    notifyListeners();
    return _convertToItem(result.item);
  }

  /// 10연차
  List<Bird> pullTen() {
    final results = _gachaManager.multiPull(_poolId, count: 10);
    notifyListeners();
    return results.map((r) => _convertToItem(r.item)).toList();
  }

  Bird _convertToItem(GachaItem item) {
    return Bird(
      id: item.id,
      name: item.nameKr,
      rarity: item.rarity,
    );
  }

  /// 천장까지 남은 횟수
  int get pullsUntilPity => _gachaManager.remainingPity(_poolId);

  /// 총 뽑기 횟수
  int get totalPulls => _gachaManager.getPityState(_poolId)?.totalPulls ?? 0;

  /// 통계
  GachaStats get stats => _gachaManager.getStats(_poolId);

  Map<String, dynamic> toJson() => _gachaManager.toJson();
  void loadFromJson(Map<String, dynamic> json) {
    _gachaManager.loadFromJson(json);
    notifyListeners();
  }
}
