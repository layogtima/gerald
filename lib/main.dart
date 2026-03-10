import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'overlays/game_over.dart';
import 'overlays/main_menu.dart';
import 'overlays/report_ui.dart';
import 'overlays/round_intro.dart';

void main() {
  runApp(const NeighborhoodWatchApp());
}

class NeighborhoodWatchApp extends StatelessWidget {
  const NeighborhoodWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = NeighborhoodWatchGame();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neighborhood Watch',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            'main_menu': (context, game) =>
                MainMenuOverlay(game: game as NeighborhoodWatchGame),
            'round_intro': (context, game) =>
                RoundIntroOverlay(game: game as NeighborhoodWatchGame),
            'report_ui': (context, game) =>
                ReportUiOverlay(game: game as NeighborhoodWatchGame),
            'game_over_win': (context, game) =>
                GameOverWinOverlay(game: game as NeighborhoodWatchGame),
            'game_over_lose': (context, game) =>
                GameOverLoseOverlay(game: game as NeighborhoodWatchGame),
          },
        ),
      ),
    );
  }
}
