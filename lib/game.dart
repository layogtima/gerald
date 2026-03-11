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
import 'components/focus_slider.dart';
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
  evidenceBoard,
}

/// Evidence photo — captured by double-tapping an NPC.
class EvidencePhoto {
  final ActivityData activity;
  final int shift;
  EvidencePhoto({required this.activity, required this.shift});
}

/// Vision mode for the binoculars.
enum VisionMode { normal, nightVision, thermal }

class NeighborhoodWatchGame extends FlameGame with PanDetector, ScaleDetector {
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
  int currentRound = 0; // endless — no cap
  int tension = 0; // Hidden tension (0-∞), drives tier escalation
  int reportsFiledThisRound = 0;
  double roundTimeRemaining = 90.0;
  bool isZoomedIn = false;

  // Track reports filed this shift for Gerald's letter
  List<({ActivityData activity, ReportOption report})> shiftReports = [];

  // ALL reports filed this game (for letter history / narrative arc)
  List<({int shift, ActivityData activity, ReportOption report})> allReports =
      [];

  // Dead-end ending text (set when a dead-end choice is picked)
  String? lastDeadEnd;

  // Activity pool depletion — once interacted, never appears again
  Set<Activity> usedActivities = {};

  // Evidence board — photos persist across shifts
  List<EvidencePhoto> evidencePhotos = [];

  // Vision mode
  VisionMode visionMode = VisionMode.normal;

  // Pinch-to-zoom state
  double _currentZoomLevel = 1.0;
  static const double _minZoom = 1.0;
  static const double _maxZoom = 3.0;

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
  late FocusSliderComponent focusSlider;

  RoundConfig get currentConfig => configForShift(currentRound);

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

    // Observation zones aligned to background geometry
    final windowSize = Vector2(80, 70);
    final yardSize = Vector2(120, 55);
    final streetSize = Vector2(140, 35);

    zones = [
      ObservationZone(position: Vector2(60, 140), label: 'Window 1', zoneType: ZoneType.window, zoneSize: windowSize),
      ObservationZone(position: Vector2(320, 120), label: 'Window 2', zoneType: ZoneType.window, zoneSize: windowSize),
      ObservationZone(position: Vector2(620, 150), label: 'Window 3', zoneType: ZoneType.window, zoneSize: windowSize),
      ObservationZone(position: Vector2(900, 130), label: 'Window 4', zoneType: ZoneType.window, zoneSize: windowSize),
      ObservationZone(position: Vector2(1200, 145), label: 'Window 5', zoneType: ZoneType.window, zoneSize: windowSize),
      ObservationZone(position: Vector2(1500, 125), label: 'Window 6', zoneType: ZoneType.window, zoneSize: windowSize),

      ObservationZone(position: Vector2(75, 355), label: 'Yard 1', zoneType: ZoneType.yard, zoneSize: yardSize),
      ObservationZone(position: Vector2(340, 355), label: 'Yard 2', zoneType: ZoneType.yard, zoneSize: yardSize),
      ObservationZone(position: Vector2(635, 355), label: 'Yard 3', zoneType: ZoneType.yard, zoneSize: yardSize),
      ObservationZone(position: Vector2(925, 355), label: 'Yard 4', zoneType: ZoneType.yard, zoneSize: yardSize),
      ObservationZone(position: Vector2(1215, 355), label: 'Yard 5', zoneType: ZoneType.yard, zoneSize: yardSize),
      ObservationZone(position: Vector2(1530, 355), label: 'Yard 6', zoneType: ZoneType.yard, zoneSize: yardSize),

      ObservationZone(position: Vector2(250, 420), label: 'Sidewalk W', zoneType: ZoneType.street, zoneSize: streetSize),
      ObservationZone(position: Vector2(850, 420), label: 'Sidewalk C', zoneType: ZoneType.street, zoneSize: streetSize),
      ObservationZone(position: Vector2(1450, 420), label: 'Sidewalk E', zoneType: ZoneType.street, zoneSize: streetSize),
    ];
    world.addAll(zones);

    // Gerald mutter (viewport space)
    geraldMutter = GeraldMutterComponent();
    camera.viewport.add(geraldMutter);

    // Focus slider (viewport space, visible when zoomed)
    focusSlider = FocusSliderComponent();
    camera.viewport.add(focusSlider);

    // Binocular overlay
    binocularOverlay = BinocularOverlay();
    camera.viewport.add(binocularOverlay);

    // CRT overlay
    crtOverlay = CrtOverlay();
    camera.viewport.add(crtOverlay);

    // HUD
    hud = HudComponent();
    camera.viewport.add(hud);

    // Show main menu
    overlays.add('main_menu');
  }

  // --- Camera Panning ---

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (gameState == GameState.evidenceBoard) return;
    if (gameState != GameState.playing && gameState != GameState.reportOpen) {
      return;
    }

    final delta = info.delta.global;

    // If zoomed in for report, handle focus slider drag
    if (isZoomedIn) {
      focusSlider.onDrag(-delta.y);
      return;
    }

    final vf = camera.viewfinder.position;
    final sensitivity = panSensitivity / _currentZoomLevel;
    final newX = (vf.x - delta.x * sensitivity).clamp(
      gameWidth / (2 * _currentZoomLevel),
      worldWidth - gameWidth / (2 * _currentZoomLevel),
    );
    final newY = (vf.y - delta.y * sensitivity).clamp(
      gameHeight / (2 * _currentZoomLevel),
      worldHeight - gameHeight / (2 * _currentZoomLevel),
    );

    camera.viewfinder.position = Vector2(newX, newY);
  }

  // --- Pinch-to-Zoom ---

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (gameState != GameState.playing || isZoomedIn) return;

    final scale = info.scale.global;
    if (scale.x == 1.0 && scale.y == 1.0) return; // Not a pinch

    final avgScale = (scale.x + scale.y) / 2;
    final newZoom = (_currentZoomLevel * avgScale).clamp(_minZoom, _maxZoom);

    if ((newZoom - _currentZoomLevel).abs() > 0.01) {
      _currentZoomLevel = newZoom;
      camera.viewfinder.zoom = _currentZoomLevel;

      // Clamp viewfinder position to new bounds
      final vf = camera.viewfinder.position;
      camera.viewfinder.position = Vector2(
        vf.x.clamp(
          gameWidth / (2 * _currentZoomLevel),
          worldWidth - gameWidth / (2 * _currentZoomLevel),
        ),
        vf.y.clamp(
          gameHeight / (2 * _currentZoomLevel),
          worldHeight - gameHeight / (2 * _currentZoomLevel),
        ),
      );
    }
  }

  // --- Game Flow ---

  void startGame() {
    overlays.remove('main_menu');
    tension = 0;
    currentRound = 0;
    lastDeadEnd = null;
    usedActivities = {};
    allReports = [];
    evidencePhotos = [];
    visionMode = VisionMode.normal;
    _currentZoomLevel = 1.0;
    camera.viewfinder.zoom = 1.0;
    crtOverlay.nightVisionActive = false;
    crtOverlay.thermalActive = false;
    startRound();
  }

  void startRound() {
    reportsFiledThisRound = 0;
    _npcsSpawnedThisRound = 0;
    shiftReports = [];
    roundTimeRemaining = currentConfig.roundDurationSeconds;
    _spawnTimer = 0;
    _nextSpawnDelay = 1.5;

    // Clear any leftover NPCs
    for (final zone in zones) {
      zone.clearNpc();
    }

    // Reset camera to center, reset manual zoom
    _currentZoomLevel = 1.0;
    camera.viewfinder.zoom = 1.0;
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

    roundTimeRemaining -= dt;

    final allSpawned = _npcsSpawnedThisRound >= currentConfig.totalNpcs;
    final noneActive = !zones.any((z) => z.hasNpc);

    if (roundTimeRemaining <= 0 || (allSpawned && noneActive)) {
      roundTimeRemaining = roundTimeRemaining.clamp(0, double.infinity);
      _endRound();
      return;
    }

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

    final activeNpcs = zones.where((z) => z.hasNpc).length;
    if (activeNpcs >= currentConfig.maxSimultaneousNpcs) return;

    final emptyZones = zones.where((z) => !z.hasNpc).toList();
    if (emptyZones.isEmpty) return;

    final zone = emptyZones[_random.nextInt(emptyZones.length)];
    final tier = tierForShift(currentRound);
    final compatible = allActivities
        .where((a) => a.compatibleZones.contains(zone.zoneType))
        .where((a) => a.tier <= tier)
        .where((a) => !usedActivities.contains(a.activity))
        .toList();

    if (compatible.isEmpty) {
      // Pool exhausted for this zone type — try to end gracefully
      _npcsSpawnedThisRound = currentConfig.totalNpcs; // stop spawning
      return;
    }

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

    // Show focus slider
    focusSlider.visible = true;
    focusSlider.focusLevel = 0.5;

    _zoomIn(npc);
    overlays.add('report_ui');
  }

  /// Double-tap to photograph an NPC for the evidence board.
  void onNpcDoubleTapped(Npc npc) {
    if (gameState != GameState.playing) return;

    // Check if already photographed
    final alreadyHave = evidencePhotos
        .any((p) => p.activity.activity == npc.activityData.activity);
    if (alreadyHave) return;

    evidencePhotos.add(EvidencePhoto(
      activity: npc.activityData,
      shift: currentRound,
    ));

    // Flash effect on NPC (visual feedback)
    npc.flashCapture();

    // Gerald reacts
    geraldMutter.triggerReaction(tension);
  }

  void onReportFiled(ReportOption report) {
    if (observedNpc == null) return;

    tension += report.tension;
    reportsFiledThisRound++;

    // Track for letter
    shiftReports.add((activity: observedNpc!.activityData, report: report));
    allReports.add((
      shift: currentRound,
      activity: observedNpc!.activityData,
      report: report,
    ));

    // Mark activity as used — never spawns again
    usedActivities.add(observedNpc!.activityData.activity);

    // Gerald mutters a reaction
    geraldMutter.triggerReaction(tension);

    // Hide focus slider
    focusSlider.visible = false;

    // Check for dead-end
    if (report.deadEnd != null) {
      observedNpc!.parentZone.clearNpc();
      observedNpc = null;
      overlays.remove('report_ui');
      _zoomOut();
      isZoomedIn = false;
      lastDeadEnd = report.deadEnd;
      gameState = GameState.gameOver;
      overlays.add('game_over');
      return;
    }

    observedNpc!.parentZone.clearNpc();
    observedNpc = null;
    overlays.remove('report_ui');
    _zoomOut();
    isZoomedIn = false;
    gameState = GameState.playing;
  }

  void onReportDismissed() {
    // Dismissed — NPC goes back to pool (NOT marked as used)
    if (observedNpc != null) {
      observedNpc!.unfreezeTimer();
      observedNpc = null;
    }

    // Hide focus slider
    focusSlider.visible = false;

    // Gerald mutters about dismissal
    geraldMutter.triggerDismiss();

    overlays.remove('report_ui');
    _zoomOut();
    isZoomedIn = false;
    gameState = GameState.playing;
  }

  void onNpcExpired(Npc npc) {
    // Gerald mutters about missing one
    geraldMutter.triggerMissed();
  }

  // --- Vision Mode ---

  void cycleVisionMode() {
    switch (visionMode) {
      case VisionMode.normal:
        visionMode = VisionMode.nightVision;
        crtOverlay.nightVisionActive = true;
        crtOverlay.thermalActive = false;
      case VisionMode.nightVision:
        visionMode = VisionMode.thermal;
        crtOverlay.nightVisionActive = false;
        crtOverlay.thermalActive = true;
      case VisionMode.thermal:
        visionMode = VisionMode.normal;
        crtOverlay.nightVisionActive = false;
        crtOverlay.thermalActive = false;
    }
  }

  // --- Evidence Board ---

  void openEvidenceBoard() {
    if (gameState != GameState.playing) return;
    gameState = GameState.evidenceBoard;
    overlays.add('evidence_board');
  }

  void closeEvidenceBoard() {
    overlays.remove('evidence_board');
    gameState = GameState.playing;
  }

  // --- Zoom ---

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
        Vector2.all(_currentZoomLevel),
        EffectController(duration: 0.25, curve: Curves.easeInOut),
      ),
    );
  }

  void _endRound() {
    for (final zone in zones) {
      zone.clearNpc();
    }

    // Check if activity pool is exhausted
    final tier = tierForShift(currentRound + 1);
    final remaining = allActivities
        .where((a) => a.tier <= tier)
        .where((a) => !usedActivities.contains(a.activity))
        .length;
    if (remaining == 0) {
      lastDeadEnd =
          'Gerald has filed a report on every person, every activity, every moment.\n\n'
          'There is nothing left to watch.\n\n'
          'The street is quiet. The binoculars sit on the windowsill.\n'
          'Gerald stares at an empty street and wonders if it was ever full.';
      gameState = GameState.gameOver;
      overlays.add('game_over');
      return;
    }

    gameState = GameState.roundEnd;
    overlays.add('round_result');
  }

  /// Called from Gerald's letter overlay after the player acknowledges
  void onRoundResultDismissed() {
    overlays.remove('round_result');
    // Endless — always advance to next shift
    currentRound++;
    startRound();
  }

  void returnToMenu() {
    overlays.remove('game_over');
    gameState = GameState.menu;
    overlays.add('main_menu');
  }
}
