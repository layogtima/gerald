import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';

import 'components/background.dart';
import 'components/binocular_overlay.dart';
import 'components/gerald_mutter.dart';
import 'components/hud.dart';
import 'components/npc.dart';
import 'components/observation_zone.dart';
import 'components/score_popup.dart';
import 'data/reports.dart';
import 'data/round_config.dart';

enum GameState {
  menu,
  roundIntro,
  playing,
  reportOpen,
  roundEnd,
  gameOver,
}

class NeighborhoodWatchGame extends FlameGame {
  static const double gameWidth = 960;
  static const double gameHeight = 540;

  // Game state
  GameState gameState = GameState.menu;
  int currentRound = 0; // 0-indexed, display as +1
  int score = 0;
  int reportsFiledThisRound = 0;
  double roundTimeRemaining = 90.0;
  bool isZoomedIn = false;

  // Currently observed NPC
  Npc? observedNpc;

  // Spawn management
  double _spawnTimer = 0;
  double _nextSpawnDelay = 2.0;
  final Random _random = Random();

  // Components
  late List<ObservationZone> zones;
  late HudComponent hud;
  late GeraldMutterComponent geraldMutter;
  late BinocularOverlay binocularOverlay;

  RoundConfig get currentConfig => roundConfigs[currentRound];

  @override
  Future<void> onLoad() async {
    // Set up camera with fixed resolution
    camera = CameraComponent.withFixedResolution(
      width: gameWidth,
      height: gameHeight,
    );

    // Background
    world.add(BackgroundComponent());

    // Create 6 observation zones at fixed positions
    zones = [
      ObservationZone(position: Vector2(100, 180), label: 'Front Yard Left'),
      ObservationZone(position: Vector2(340, 140), label: 'Upstairs Window'),
      ObservationZone(position: Vector2(560, 140), label: 'Upstairs Right'),
      ObservationZone(position: Vector2(160, 340), label: 'Porch'),
      ObservationZone(position: Vector2(500, 340), label: 'Driveway'),
      ObservationZone(position: Vector2(760, 280), label: 'Side Yard'),
    ];
    world.addAll(zones);

    // Gerald mutter
    geraldMutter = GeraldMutterComponent();
    world.add(geraldMutter);

    // Binocular overlay (rendered on top of everything in world)
    binocularOverlay = BinocularOverlay();
    world.add(binocularOverlay);

    // HUD (added to viewport)
    hud = HudComponent();
    camera.viewport.add(hud);

    // Show main menu
    overlays.add('main_menu');
  }

  void startGame() {
    overlays.remove('main_menu');
    score = 0;
    currentRound = 0;
    startRound();
  }

  void startRound() {
    reportsFiledThisRound = 0;
    roundTimeRemaining = currentConfig.roundDurationSeconds;
    _spawnTimer = 0;
    _nextSpawnDelay = 1.5; // First NPC spawns quickly

    // Clear any leftover NPCs
    for (final zone in zones) {
      zone.clearNpc();
    }

    gameState = GameState.roundIntro;
    overlays.add('round_intro');
  }

  void beginPlaying() {
    overlays.remove('round_intro');
    gameState = GameState.playing;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameState != GameState.playing) return;

    // Update round timer
    roundTimeRemaining -= dt;
    if (roundTimeRemaining <= 0) {
      roundTimeRemaining = 0;
      _endRound();
      return;
    }

    // Spawn NPCs
    _spawnTimer += dt;
    if (_spawnTimer >= _nextSpawnDelay) {
      _spawnTimer = 0;
      _nextSpawnDelay = 1.5 + _random.nextDouble() * 2.0;
      _trySpawnNpc();
    }
  }

  void _trySpawnNpc() {
    // Count current NPCs
    final activeNpcs = zones.where((z) => z.hasNpc).length;
    if (activeNpcs >= currentConfig.maxSimultaneousNpcs) return;

    // Find empty zones
    final emptyZones = zones.where((z) => !z.hasNpc).toList();
    if (emptyZones.isEmpty) return;

    // Pick random zone and activity
    final zone = emptyZones[_random.nextInt(emptyZones.length)];
    final activityData = allActivities[_random.nextInt(allActivities.length)];

    zone.spawnNpc(activityData, currentConfig.npcVisibilitySeconds);
  }

  void onNpcTapped(Npc npc) {
    if (gameState != GameState.playing || isZoomedIn) return;

    isZoomedIn = true;
    observedNpc = npc;
    npc.freezeTimer();
    gameState = GameState.reportOpen;

    // Zoom effect: scale world toward NPC
    _zoomIn(npc);

    overlays.add('report_ui');
  }

  void onReportFiled(ReportOption report) {
    if (observedNpc == null) return;

    final npcPos = observedNpc!.absolutePosition;

    // Add score
    score += report.points;
    reportsFiledThisRound++;

    // Score popup
    world.add(ScorePopup(
      points: report.points,
      worldPosition: npcPos,
    ));

    // Remove NPC
    observedNpc!.parentZone.clearNpc();
    observedNpc = null;

    // Close report UI and zoom out
    overlays.remove('report_ui');
    _zoomOut();

    isZoomedIn = false;
    gameState = GameState.playing;
  }

  void onReportDismissed() {
    // Player can close without filing (loses opportunity)
    if (observedNpc != null) {
      observedNpc!.unfreezeTimer();
      observedNpc = null;
    }

    overlays.remove('report_ui');
    _zoomOut();

    isZoomedIn = false;
    gameState = GameState.playing;
  }

  void onNpcExpired(Npc npc) {
    // Screen shake for missed NPC
    _screenShake();
  }

  void _zoomIn(Npc npc) {
    final npcWorldPos = npc.absolutePosition;
    camera.viewfinder.add(
      ScaleEffect.to(
        Vector2.all(1.8),
        EffectController(duration: 0.3, curve: Curves.easeOutBack),
      ),
    );
    camera.viewfinder.add(
      MoveEffect.to(
        npcWorldPos,
        EffectController(duration: 0.3, curve: Curves.easeOutBack),
      ),
    );
  }

  void _zoomOut() {
    camera.viewfinder.add(
      ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(duration: 0.25, curve: Curves.easeInOut),
      ),
    );
    camera.viewfinder.add(
      MoveEffect.to(
        Vector2(gameWidth / 2, gameHeight / 2),
        EffectController(duration: 0.25, curve: Curves.easeInOut),
      ),
    );
  }

  void _screenShake() {
    camera.viewfinder.add(
      MoveEffect.by(
        Vector2(4, 0),
        EffectController(
          duration: 0.05,
          reverseDuration: 0.05,
          repeatCount: 3,
        ),
      ),
    );
  }

  void _endRound() {
    // Clear NPCs
    for (final zone in zones) {
      zone.clearNpc();
    }

    if (reportsFiledThisRound >= currentConfig.quota) {
      // Passed this round
      if (currentRound >= 4) {
        // Won the game!
        gameState = GameState.gameOver;
        overlays.add('game_over_win');
      } else {
        currentRound++;
        startRound();
      }
    } else {
      // Failed
      gameState = GameState.gameOver;
      overlays.add('game_over_lose');
    }
  }

  void returnToMenu() {
    overlays.remove('game_over_win');
    overlays.remove('game_over_lose');
    gameState = GameState.menu;
    overlays.add('main_menu');
  }
}
