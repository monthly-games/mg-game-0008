import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/economy/gold_manager.dart';
import '../game/skin_manager.dart';
import '../game/theme_manager.dart';

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
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A90E2),
      appBar: AppBar(
        title: const Text(
          'Shop',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Gold Display
          // Gold Display
          StreamBuilder<int>(
            stream: _goldManager.onGoldChanged,
            initialData: _goldManager.currentGold,
            builder: (context, snapshot) {
              final gold = snapshot.data ?? 0;
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$gold',
                      style: const TextStyle(
                        color: Colors.white,
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
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amber,
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
          padding: const EdgeInsets.all(16),
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
          padding: const EdgeInsets.all(16),
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
          padding: const EdgeInsets.all(16),
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
        return Colors.red;
      case BirdSkin.blue:
        return Colors.blue;
      case BirdSkin.gold:
        return Colors.amber;
    }
  }

  Color _getPipeColor(PipeSkin skin) {
    switch (skin) {
      case PipeSkin.green:
        return Colors.green;
      case PipeSkin.red:
        return Colors.redAccent;
      case PipeSkin.metallic:
        return Colors.blueGrey;
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Colors.amber, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'SELECTED',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            else if (isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'OWNED',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
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
