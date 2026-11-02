import 'package:flutter/material.dart';

import '../../core/app_config.dart';
import 'placeholder_page.dart';

typedef HomeTile = ({IconData icon, String label});

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const tiles = <HomeTile>[
    (icon: Icons.cloud_outlined, label: 'Network'),
    (icon: Icons.notifications_outlined, label: 'Notifications'),
    (icon: Icons.photo_camera_outlined, label: 'Camera'),
    (icon: Icons.fingerprint, label: 'Security'),
    (icon: Icons.settings_outlined, label: 'Settings'),
    (icon: Icons.info_outline, label: 'About'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: GridView.extent(
          maxCrossAxisExtent: 200,
          padding: const EdgeInsets.all(16),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [for (final tile in tiles) _HomeTileCard(tile: tile)],
        ),
      ),
      bottomNavigationBar: AppConfig.isProduction
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${AppConfig.environment} · ${AppConfig.apiBaseUrl}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
    );
  }
}

class _HomeTileCard extends StatelessWidget {
  const _HomeTileCard({required this.tile});

  final HomeTile tile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card.filled(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PlaceholderPage(title: tile.label),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tile.icon, size: 40, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(tile.label, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
