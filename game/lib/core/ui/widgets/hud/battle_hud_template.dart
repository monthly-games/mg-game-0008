import 'package:flutter/material.dart';
import 'package:mg_common_game/mg_common_game.dart';

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
    required this.enemyTotal,
    this.isPlayerTurn = true,
    this.isBattleOver = false,
    this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    final accent = themeColor ?? (isPlayerTurn ? MGColors.success : MGColors.error);

    return SafeArea(
      child: Column(
        children: [
          _buildStageInfo(accent),
          MGSpacing.vSm,
          _buildUnitStatus(),
        ],
      ),
    );
  }

  Widget _buildStageInfo(Color accent) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MGSpacing.md,
        vertical: MGSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: MGColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent),
      ),
      child: Text(
        stageLabel == null ? 'Turn $turn' : '$stageLabel - Turn $turn',
        style: MGTextStyles.hud.copyWith(
          color: MGColors.textHighEmphasis,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUnitStatus() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MGSpacing.sm,
        vertical: MGSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: MGColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MGColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person, color: MGColors.success, size: 18),
          MGSpacing.hXs,
          Text(
            '$playerAlive/$playerTotal',
            style: MGTextStyles.hudSmall.copyWith(
              color: MGColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
          MGSpacing.hSm,
          Icon(Icons.smart_toy, color: MGColors.error, size: 18),
          MGSpacing.hXs,
          Text(
            '$enemyAlive/$enemyTotal',
            style: MGTextStyles.hudSmall.copyWith(
              color: MGColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isBattleOver) ...[
            MGSpacing.hSm,
            Text(
              isPlayerTurn ? 'Victory' : 'Defeat',
              style: MGTextStyles.hudSmall.copyWith(
                color: isPlayerTurn ? MGColors.success : MGColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
