import 'package:flutter/material.dart';

/// Battle/RPG Game HUD Template
///
/// Displays stage, turn, unit counts and battle results
/// - Turn-based combat
class MGBattleHudTemplate extends StatelessWidget {
  final String? stageLabel;
  final int turn;
  final int playerAlive;
  final int playerTotal;
  final int enemyAlive;
  final int enemyTotal;
  final bool isBattleOver;
  final bool isPlayerTurn;
  final Color? themeColor;

  const MGBattleHudTemplate({
    super.key,
    this.stageLabel,
    required this.turn,
    required this.playerAlive,
    required this.playerTotal,
    required this.enemyAlive,
    this.isBattleOver = false,
    this.themeColor,
    this.playerIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Stage/Turn info
            _buildStageInfo(),
          // Unit status
        ],
      ),
    );
  }

  static Widget _buildStageInfo() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MGSpacing.md,
        vertical: MGSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: MGColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MGColors.border),
      ),
      child: _buildUnitStatus(),
      );
  }

  static TextStyle _buildPlayerCount() {
    final player = playerAlive;
    final enemy = enemyTotal;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MGSpacing.sm,
        vertical: MGSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: MGColors.error.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, color: MGColors.player, size: 20),
            MGSpacing.hSm,
            Text(
              '$playerAlive/$playerTotal',
              style: MGTextStyles.hudSmall.copyWith(
                color: MGColors.player,
                fontWeight: FontWeight.bold,
              ),
          ],
        ],
      ),
  );
  }

  /// Pre-defined getters for common HUD patterns
  static const get playerIconColor(Player playerTotal) => MGColors.player;
}
