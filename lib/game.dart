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
import 'components/npc.dart';
import 'components/observation_zone.dart';
import 'data/reports.dart';
import 'data/round_config.dart';
import 'data/story.dart';
import 'data/zone_type.dart';

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
  int tension = 0; // Hidden tension meter (0-100+), drives story
  int reportsFiledThisRound = 0;
  double roundTimeRemaining = 90.0;
  bool isZoomedIn = false;

  // Track reports filed this shift for newspaper
  List<({ActivityData activity, ReportOption report})> shiftReports = [];

  // NPC spawn tracking
  int _npcsSpawnedThisRound = 0;

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
  ShiftStory get currentStory => shiftStories[currentRound];

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

    // Observation zones aligned to background geometry:
    // Houses bottom at y≈350, sidewalk at y≈416-448
    final windowSize = Vector2(80, 70);
    final yardSize = Vector2(120, 55);
    final streetSize = Vector2(140, 35);

    zones = [
      // Window zones (inside house walls, at upper window height)
      ObservationZone(position: Vector2(60, 140), label: '1st Ave Window', zoneType: ZoneType.window, zoneSize: windowSize),
      ObservationZone(position: Vector2(320, 120), label: '2nd Ave Window', zoneType: ZoneType.window, zoneSize: windowSize),
      ObservationZone(position: Vector2(620, 150), label: '3rd Ave Window', zoneType: ZoneType.window, zoneSize: windowSize),
      ObservationZone(position: Vector2(900, 130), label: '4th Ave Window', zoneType: ZoneType.window, zoneSize: windowSize),
      ObservationZone(position: Vector2(1200, 145), label: '5th Ave Window', zoneType: ZoneType.window, zoneSize: windowSize),
      ObservationZone(position: Vector2(1500, 125), label: '6th Ave Window', zoneType: ZoneType.window, zoneSize: windowSize),

      // Yard zones (front of each house, grass area)
      ObservationZone(position: Vector2(75, 355), label: '1st Ave Yard', zoneType: ZoneType.yard, zoneSize: yardSize),
      ObservationZone(position: Vector2(340, 355), label: '2nd Ave Yard', zoneType: ZoneType.yard, zoneSize: yardSize),
      ObservationZone(position: Vector2(635, 355), label: '3rd Ave Yard', zoneType: ZoneType.yard, zoneSize: yardSize),
      ObservationZone(position: Vector2(925, 355), label: '4th Ave Yard', zoneType: ZoneType.yard, zoneSize: yardSize),
      ObservationZone(position: Vector2(1215, 355), label: '5th Ave Yard', zoneType: ZoneType.yard, zoneSize: yardSize),
      ObservationZone(position: Vector2(1530, 355), label: '6th Ave Yard', zoneType: ZoneType.yard, zoneSize: yardSize),

      // Street zones (on upper sidewalk)
      ObservationZone(position: Vector2(250, 420), label: 'Sidewalk West', zoneType: ZoneType.street, zoneSize: streetSize),
      ObservationZone(position: Vector2(850, 420), label: 'Sidewalk Central', zoneType: ZoneType.street, zoneSize: streetSize),
      ObservationZone(position: Vector2(1450, 420), label: 'Sidewalk East', zoneType: ZoneType.street, zoneSize: streetSize),
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
    tension = 0;
    currentRound = 0;
    startRound();
  }

  void startRound() {
    reportsFiledThisRound = 0;
    _npcsSpawnedThisRound = 0;
    shiftReports = [];
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

    // Check if shift should end: timer expired OR all NPCs spawned and none active
    final allSpawned = _npcsSpawnedThisRound >= currentConfig.totalNpcs;
    final noneActive = !zones.any((z) => z.hasNpc);

    if (roundTimeRemaining <= 0 || (allSpawned && noneActive)) {
      roundTimeRemaining = roundTimeRemaining.clamp(0, double.infinity);
      _endRound();
      return;
    }

    // Spawn NPCs (only if we haven't spawned them all yet)
    if (!allSpawned) {
      _spawnTimer += dt;
      if (_spawnTimer >= _nextSpawnDelay) {
        _spawnTimer = 0;
        _nextSpawnDelay = 1.5 + _random.nextDouble() * 2.0;
        _trySpawnNpc();
      }
    }
  }

  void _trySpawnNpc() {
    if (_npcsSpawnedThisRound >= currentConfig.totalNpcs) return;

    // Count current NPCs
    final activeNpcs = zones.where((z) => z.hasNpc).length;
    if (activeNpcs >= currentConfig.maxSimultaneousNpcs) return;

    // Find empty zones
    final emptyZones = zones.where((z) => !z.hasNpc).toList();
    if (emptyZones.isEmpty) return;

    // Pick random zone, then pick a compatible activity
    final zone = emptyZones[_random.nextInt(emptyZones.length)];
    final act = actForShift(currentRound);
    final compatible = allActivities
        .where((a) => a.compatibleZones.contains(zone.zoneType))
        .where((a) => a.minAct <= act)
        .toList();
    if (compatible.isEmpty) return;

    final activityData = compatible[_random.nextInt(compatible.length)];
    zone.spawnNpc(activityData, currentConfig.npcVisibilitySeconds);
    _npcsSpawnedThisRound++;
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

    // Add tension (hidden)
    tension += report.points;
    reportsFiledThisRound++;

    // Track for newspaper
    shiftReports.add((activity: observedNpc!.activityData, report: report));

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
    // Player can close without filing — no penalty
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
    // NPCs expire silently — no popup, no screen shake
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
  }

  void _endRound() {
    // Clear NPCs
    for (final zone in zones) {
      zone.clearNpc();
    }

    gameState = GameState.roundEnd;
    overlays.add('round_result');
  }

  /// Called from round result overlay after the player acknowledges
  void onRoundResultDismissed() {
    overlays.remove('round_result');

    if (currentRound >= 5) {
      // All 6 shifts complete — game over with tension-based ending
      gameState = GameState.gameOver;
      overlays.add('game_over');
    } else {
      currentRound++;
      startRound();
    }
  }

  void returnToMenu() {
    overlays.remove('game_over');
    gameState = GameState.menu;
    overlays.add('main_menu');
  }
}
