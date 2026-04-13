import 'package:mg_common_game/core/ui/layout/mg_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import '../game/skin_manager.dart';
import '../game/theme_manager.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GoldManager _goldManager = GetIt.I<GoldManager>();
  final SkinManager _skinManager = GetIt.I<SkinManager>();
  final ThemeManager _themeManager = GetIt.I<ThemeManager>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: MGColors.error),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: MGColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MGColors.info,
      appBar: AppBar(
        title: const Text(
          'Shop',
          style: TextStyle(color: MGColors.textHighEmphasis, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: MGColors.textHighEmphasis),
        actions: [
          // Gold Display
          // Gold Display
          AnimatedBuilder(
            animation: _goldManager,
            builder: (context, child) {
              final gold = _goldManager.currentGold;

              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: MGColors.backgroundDark.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: MGColors.gold,
                      size: 20,
                    ),
                    const SizedBox(width: MGSpacing.xxs),
                    Text(
                      '$gold',
                      style: const TextStyle(
                        color: MGColors.textHighEmphasis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: MGColors.textHighEmphasis,
          unselectedLabelColor: MGColors.textMediumEmphasis,
          indicatorColor: MGColors.gold,
          tabs: const [
            Tab(text: 'Birds', icon: Icon(Icons.catching_pokemon)),
            Tab(text: 'Pipes', icon: Icon(Icons.view_column)),
            Tab(text: 'Themes', icon: Icon(Icons.landscape)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildBirdTab(), _buildPipeTab(), _buildThemeTab()],
      ),
    );
  }

  Widget _buildBirdTab() {
    return ListenableBuilder(
      listenable: _skinManager,
      builder: (context, _) {
        return GridView.builder(
          padding: const EdgeInsets.all(MGSpacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: BirdSkin.values.length,
          itemBuilder: (context, index) {
            final skin = BirdSkin.values[index];
            final isUnlocked = _skinManager.isBirdUnlocked(skin);
            final isSelected = _skinManager.currentBirdSkin == skin;

            return _buildShopItemCard(
              title: skin.name,
              cost: skin.cost,
              isUnlocked: isUnlocked,
              isSelected: isSelected,
              onTap: () {
                if (isSelected) return;
                if (isUnlocked) {
                  _skinManager.setBirdSkin(skin);
                } else {
                  if (_goldManager.currentGold >= skin.cost) {
                    _goldManager.trySpendGold(skin.cost);
                    _skinManager.unlockBirdSkin(skin);
                    _showSuccess('Unlocked ${skin.name}!');
                  } else {
                    _showError('Not enough gold!');
                  }
                }
              },
              icon: Icons.catching_pokemon, // Placeholder, ideally use sprite
              color: _getBirdColor(skin),
            );
          },
        );
      },
    );
  }

  Widget _buildPipeTab() {
    return ListenableBuilder(
      listenable: _skinManager,
      builder: (context, _) {
        return GridView.builder(
          padding: const EdgeInsets.all(MGSpacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: PipeSkin.values.length,
          itemBuilder: (context, index) {
            final skin = PipeSkin.values[index];
            final isUnlocked = _skinManager.isPipeUnlocked(skin);
            final isSelected = _skinManager.currentPipeSkin == skin;

            return _buildShopItemCard(
              title: skin.name,
              cost: skin.cost,
              isUnlocked: isUnlocked,
              isSelected: isSelected,
              onTap: () {
                if (isSelected) return;
                if (isUnlocked) {
                  _skinManager.setPipeSkin(skin);
                } else {
                  if (_goldManager.currentGold >= skin.cost) {
                    _goldManager.trySpendGold(skin.cost);
                    _skinManager.unlockPipeSkin(skin);
                    _showSuccess('Unlocked ${skin.name}!');
                  } else {
                    _showError('Not enough gold!');
                  }
                }
              },
              icon: Icons.view_column,
              color: _getPipeColor(skin),
            );
          },
        );
      },
    );
  }

  Widget _buildThemeTab() {
    return ListenableBuilder(
      listenable: _themeManager,
      builder: (context, _) {
        return GridView.builder(
          padding: const EdgeInsets.all(MGSpacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: GameTheme.values.length,
          itemBuilder: (context, index) {
            final theme = GameTheme.values[index];
            final isUnlocked = _themeManager.isThemeUnlocked(theme);
            final isSelected = _themeManager.currentTheme == theme;

            return _buildShopItemCard(
              title: theme.name,
              cost: theme.cost,
              isUnlocked: isUnlocked,
              isSelected: isSelected,
              onTap: () {
                if (isSelected) return;
                if (isUnlocked) {
                  _themeManager.setTheme(theme);
                } else {
                  if (_goldManager.currentGold >= theme.cost) {
                    _goldManager.trySpendGold(theme.cost);
                    _themeManager.unlockTheme(theme);
                    _showSuccess('Unlocked ${theme.name}!');
                  } else {
                    _showError('Not enough gold!');
                  }
                }
              },
              icon: Icons.landscape,
              color: _getThemeColor(theme),
            );
          },
        );
      },
    );
  }

  Color _getBirdColor(BirdSkin skin) {
    switch (skin) {
      case BirdSkin.red:
        return MGColors.error;
      case BirdSkin.blue:
        return MGColors.info;
      case BirdSkin.gold:
        return MGColors.gold;
    }
  }

  Color _getPipeColor(PipeSkin skin) {
    switch (skin) {
      case PipeSkin.green:
        return MGColors.success;
      case PipeSkin.red:
        return Colors.redAccent;
      case PipeSkin.metallic:
        return MGColors.surfaceDark;
    }
  }

  Color _getThemeColor(GameTheme theme) {
    switch (theme) {
      case GameTheme.day:
        return Colors.lightBlue;
      case GameTheme.night:
        return Colors.indigo;
    }
  }

  Widget _buildShopItemCard({
    required String title,
    required int cost,
    required bool isUnlocked,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MGColors.textHighEmphasis,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: MGColors.gold, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: MGColors.backgroundDark.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(MGSpacing.md),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: color),
            ),
            const SizedBox(height: MGSpacing.sm),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: MGSpacing.xs),
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: MGColors.success,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'SELECTED',
                  style: TextStyle(color: MGColors.textHighEmphasis, fontSize: 12),
                ),
              )
            else if (isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: MGColors.common,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'OWNED',
                  style: TextStyle(color: MGColors.textHighEmphasis, fontSize: 12),
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    size: 16,
                    color: MGColors.gold,
                  ),
                  const SizedBox(width: MGSpacing.xxs),
                  Text(
                    '$cost',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
