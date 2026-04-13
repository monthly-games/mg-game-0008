import 'package:mg_common_game/core/ui/layout/mg_spacing.dart';
import 'package:flutter/material.dart';
import '../game/medal_type.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';

class GameOverOverlay extends StatelessWidget {
  final int score;
  final int bestScore;
  final VoidCallback onRestart;
  final VoidCallback onMainMenu;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.bestScore,
    required this.onRestart,
    required this.onMainMenu,
  });

  @override
  Widget build(BuildContext context) {
    final medal = MedalType.fromScore(score);
    final isNewRecord = score > 0 && score >= bestScore; // Simplified check

    return Container(
      color: MGColors.backgroundDark.withValues(alpha: 0.54),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: MGColors.textHighEmphasis,
                shadows: [
                  Shadow(
                    offset: Offset(0, 4),
                    blurRadius: 8,
                    color: MGColors.backgroundDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: MGSpacing.xl),

            // Score Board
            Container(
              width: 300,
              padding: const EdgeInsets.all(MGSpacing.lg),
              decoration: BoxDecoration(
                color: const Color(0xFFDED895), // Light yellowish/beige
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF543847), width: 4),
              ),
              child: Row(
                children: [
                  // Medal Section
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'MEDAL',
                          style: TextStyle(
                            color: Color(0xFFE86A17),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: MGSpacing.sm),
                        if (medal != MedalType.none)
                          // We can use the generated asset here later.
                          // For now, use Icon or simple color box if asset not ready.
                          // Assuming asset path is correct:
                          // Image.asset(medal.assetPath, width: 48, height: 48)
                          // But we need to load from Flame assets or Flutter assets.
                          // Let's use Icons for now or colored circle.
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getMedalColor(medal),
                              border: Border.all(color: MGColors.backgroundDark, width: 2),
                              boxShadow: const [
                                BoxShadow(blurRadius: 4, offset: Offset(0, 2)),
                              ],
                            ),
                            child: const Icon(
                              Icons.emoji_events,
                              color: MGColors.textHighEmphasis,
                            ),
                          )
                        else
                          const SizedBox(width: 48, height: 48), // Empty
                      ],
                    ),
                  ),

                  // Score Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'SCORE',
                          style: TextStyle(
                            color: Color(0xFFE86A17),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$score',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: MGColors.textHighEmphasis,
                            shadows: [
                              Shadow(offset: Offset(1, 1), color: MGColors.backgroundDark),
                            ],
                          ),
                        ),
                        const SizedBox(height: MGSpacing.md),
                        const Text(
                          'BEST',
                          style: TextStyle(
                            color: Color(0xFFE86A17),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$bestScore',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: MGColors.textHighEmphasis,
                            shadows: [
                              Shadow(offset: Offset(1, 1), color: MGColors.backgroundDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (isNewRecord)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: MGColors.error,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'NEW HIGH SCORE!',
                    style: TextStyle(
                      color: MGColors.textHighEmphasis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: MGSpacing.xl),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  icon: Icons.play_arrow,
                  color: MGColors.success,
                  onTap: onRestart,
                ),
                const SizedBox(width: MGSpacing.lg),
                _buildButton(
                  icon: Icons.menu,
                  color: MGColors.info,
                  onTap: onMainMenu,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getMedalColor(MedalType type) {
    switch (type) {
      case MedalType.bronze:
        return const Color(0xFFCD7F32);
      case MedalType.silver:
        return const Color(0xFFC0C0C0);
      case MedalType.gold:
        return MGColors.gold;
      case MedalType.platinum:
        return const Color(0xFFE5E4E2);
      default:
        return Colors.transparent;
    }
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: MGColors.textHighEmphasis, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: MGColors.textHighEmphasis, size: 40),
        ),
      ),
    );
  }
}
