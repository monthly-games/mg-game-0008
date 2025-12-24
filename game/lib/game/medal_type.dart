enum MedalType {
  none,
  bronze,
  silver,
  gold,
  platinum; // 100+

  static MedalType fromScore(int score) {
    if (score >= 100) return MedalType.platinum;
    if (score >= 50) return MedalType.gold;
    if (score >= 20) return MedalType.silver;
    if (score >= 10) return MedalType.bronze;
    return MedalType.none;
  }

  String get assetPath {
    switch (this) {
      case MedalType.platinum:
        return 'assets/images/medal_platinum.png';
      case MedalType.gold:
        return 'assets/images/medal_gold.png';
      case MedalType.silver:
        return 'assets/images/medal_silver.png';
      case MedalType.bronze:
        return 'assets/images/medal_bronze.png';
      case MedalType.none:
        return '';
    }
  }
}
