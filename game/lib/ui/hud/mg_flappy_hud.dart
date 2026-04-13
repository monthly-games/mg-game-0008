import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mg_common_game/core/ui/mg_ui.dart';

/// MG UI 기반 플래피 게임 HUD
/// mg_common_game의 공통 UI 컴포넌트 활용
class MGFlappyHud extends StatelessWidget {
  final int score;
  final int highScore;
  final int coins;
  final bool isPaused;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onDailyHub;
  final VoidCallback? onGuildWar;
  final VoidCallback? onTournament;
  final VoidCallback? onSeasonalEvent;

  const MGFlappyHud({
    super.key,
    required this.score,
    this.highScore = 0,
    this.coins = 0,
    this.isPaused = false,
    this.onPause,
    this.onResume,
    this.onDailyHub,
    this.onGuildWar,
    this.onTournament,
    this.onSeasonalEvent,
  });

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.of(context).padding;

    return Positioned.fill(
      child: Column(
        children: [
          // 상단 HUD: 점수 + 코인
          Container(
            padding: EdgeInsets.only(
              top: safeArea.top + MGSpacing.hudMargin,
              left: safeArea.left + MGSpacing.hudMargin,
              right: safeArea.right + MGSpacing.hudMargin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 일시정지 버튼
        if (onGuildWar != null)
          MGIconButton(
            icon: Icons.shield,
            onPressed: onGuildWar,
            size: 44,
            backgroundColor: MGColors.info.withValues(alpha: 0.8),
            color: MGColors.textHighEmphasis,
            tooltip: 'Guild War',
          ),
        MGSpacing.hXs,
        if (onTournament != null)
          MGIconButton(
            icon: Icons.emoji_events,
            onPressed: onTournament,
            size: 44,
            backgroundColor: MGColors.info.withValues(alpha: 0.8),
            color: MGColors.textHighEmphasis,
            tooltip: 'Tournament',
          ),
        MGSpacing.hXs,
        if (onSeasonalEvent != null)
          MGIconButton(
            icon: Icons.celebration,
            onPressed: onSeasonalEvent,
            size: 44,
            backgroundColor: MGColors.info.withValues(alpha: 0.8),
            color: MGColors.textHighEmphasis,
            tooltip: 'Seasonal Event',
          ),
        MGSpacing.hXs,
        if (onDailyHub != null)
          MGIconButton(
            icon: Icons.calendar_today,
            onPressed: onDailyHub,
            size: 44,
            backgroundColor: MGColors.info.withValues(alpha: 0.8),
            color: MGColors.textHighEmphasis,
            tooltip: 'Daily Hub',
          ),
        MGSpacing.hXs,
                MGIconButton(
                  icon: isPaused ? Icons.play_arrow : Icons.pause,
                  onPressed: isPaused ? onResume : onPause,
                  size: 44,
                  backgroundColor: MGColors.backgroundDark.withValues(alpha: 0.54),
                  color: MGColors.textHighEmphasis,
                ),

                // 점수 표시
                _buildScoreDisplay(),

                // 코인 표시
                MGResourceBar(
                  icon: Icons.monetization_on,
                  value: _formatNumber(coins),
                  iconColor: MGColors.gold,
                  onTap: null,
                ),
              ],
            ),
          ),

          // 중앙 영역 확장 (게임 영역)
          const Expanded(child: SizedBox()),
          // Spine 캐릭터
          _buildSpineCharacter(),
          const SizedBox(height: 50),

          // 하단: 최고 점수 (필요시)
          if (highScore > 0)
            Container(
              padding: EdgeInsets.only(
                bottom: safeArea.bottom + MGSpacing.hudMargin,
                left: safeArea.left + MGSpacing.hudMargin,
                right: safeArea.right + MGSpacing.hudMargin,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: MGColors.backgroundDark.withValues(alpha: 0.54),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: MGColors.gold,
                      size: 20,
                    ),
                    MGSpacing.hXs,
                    Text(
                      'Best: $highScore',
                      style: MGTextStyles.hudSmall.copyWith(
                        color: MGColors.textMediumEmphasis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: MGColors.backgroundDark.withValues(alpha: 0.54),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MGColors.warning.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Text(
        '$score',
        style: MGTextStyles.display.copyWith(
          color: MGColors.textHighEmphasis,
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }


  Widget _buildSpineCharacter() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.yellow.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.yellow.withAlpha(150), width: 2),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 24, color: Colors.white),
            SizedBox(height: 2),
            Text(
              'Flappy Bird',
              style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

}
