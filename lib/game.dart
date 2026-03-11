import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';

import 'components/background.dart';
import 'components/binocular_overlay.dart';
import 'components/crt_overlay.dart';
import 'components/gerald_mutter.dart';
import 'components/hud.dart';
import 'components/missed_popup.dart';
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

class NeighborhoodWatchGame extends FlameGame with PanDetector {
  // Viewport width is fixed; height adapts to screen aspect ratio
  static const double gameWidth = 960;
  late double gameHeight;

  // World (full scene, larger than viewport)
  static const double worldWidth = 1920;
  static const double worldHeight = 800;

  // Camera panning
  static const double panSensitivity = 1.3;

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
  late CrtOverlay crtOverlay;

  RoundConfig get currentConfig => roundConfigs[currentRound];

  @override
  Future<void> onLoad() async {
    // Compute viewport height from screen aspect ratio, capped at world height
    final view = ui.PlatformDispatcher.instance.views.first;
    final screenSize = view.physicalSize / view.devicePixelRatio;
    final aspectRatio = screenSize.width / screenSize.height;
    gameHeight = (gameWidth / aspectRatio).clamp(540.0, worldHeight);

    // Set up camera with fixed resolution viewport
    camera = CameraComponent.withFixedResolution(
      width: gameWidth,
      height: gameHeight,
    );
    // Start centered in the world
    camera.viewfinder.position = Vector2(worldWidth / 2, worldHeight / 2);

    // Background
    world.add(BackgroundComponent());

    // Create 10 observation zones spread across the wider world
    zones = [
      // Left section
      ObservationZone(position: Vector2(80, 200), label: 'Far Left Yard'),
      ObservationZone(position: Vector2(250, 150), label: 'Left Upstairs'),
      ObservationZone(position: Vector2(180, 380), label: 'Left Porch'),
      // Center-left
      ObservationZone(position: Vector2(500, 160), label: 'Center Left Window'),
      ObservationZone(position: Vector2(450, 400), label: 'Center Driveway'),
      // Center-right
      ObservationZone(position: Vector2(800, 150), label: 'Center Right Window'),
      ObservationZone(position: Vector2(750, 380), label: 'Center Yard'),
      // Right section
      ObservationZone(position: Vector2(1100, 160), label: 'Right Upstairs'),
      ObservationZone(position: Vector2(1050, 400), label: 'Right Porch'),
      ObservationZone(position: Vector2(1350, 300), label: 'Far Right Yard'),
    ];
    world.addAll(zones);

    // Gerald mutter (viewport space so it stays on screen)
    geraldMutter = GeraldMutterComponent();
    camera.viewport.add(geraldMutter);

    // Binocular overlay (rendered in VIEWPORT space — stays fixed on screen)
    binocularOverlay = BinocularOverlay();
    camera.viewport.add(binocularOverlay);

    // CRT overlay (scanlines etc, in viewport space)
    crtOverlay = CrtOverlay();
    camera.viewport.add(crtOverlay);

    // HUD (added to viewport)
    hud = HudComponent();
    camera.viewport.add(hud);

    // Show main menu
    overlays.add('main_menu');
  }

  // --- Camera Panning ---

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (gameState != GameState.playing) return;

    final delta = info.delta.global;
    final vf = camera.viewfinder.position;

    // Move camera opposite to drag direction
    final newX = (vf.x - delta.x * panSensitivity).clamp(
      gameWidth / 2,
      worldWidth - gameWidth / 2,
    );
    final newY = (vf.y - delta.y * panSensitivity).clamp(
      gameHeight / 2,
      worldHeight - gameHeight / 2,
    );

    camera.viewfinder.position = Vector2(newX, newY);
  }

  // --- Game Flow ---

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

    // Reset camera to center
    camera.viewfinder.position = Vector2(worldWidth / 2, worldHeight / 2);

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
    // "MISSED!" popup at NPC position
    world.add(MissedPopup(worldPosition: npc.absolutePosition));
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
    // Zoom out back to wherever camera was (don't reset position)
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

    gameState = GameState.roundEnd;

    if (reportsFiledThisRound >= currentConfig.quota) {
      // Show round result overlay briefly, then proceed
      overlays.add('round_result');
    } else {
      // Failed — show result then game over
      overlays.add('round_result');
    }
  }

  /// Called from round result overlay after the player acknowledges
  void onRoundResultDismissed() {
    overlays.remove('round_result');

    if (reportsFiledThisRound >= currentConfig.quota) {
      if (currentRound >= 4) {
        gameState = GameState.gameOver;
        overlays.add('game_over_win');
      } else {
        currentRound++;
        startRound();
      }
    } else {
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
