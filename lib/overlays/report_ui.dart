import 'package:flutter/material.dart';

import '../game.dart';

/// Papers Please-inspired incident report document.
/// Parchment background, typewriter text, stamp-style report options.
class ReportUiOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const ReportUiOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final npc = game.observedNpc;
    if (npc == null) return const SizedBox.shrink();

    final activity = npc.activityData;
    final now = DateTime.now();
    final formNumber =
        'NW-${game.currentRound + 1}-${now.hour}${now.minute}${now.second}';

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
            maxWidth: 520,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5E6C8),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: const Color(0xFF8B7355), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'INCIDENT REPORT',
                                style: TextStyle(
                                  color: Color(0xFF2A1A0A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'FORM $formNumber',
                                style: const TextStyle(
                                  color: Color(0xFF8B7355),
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => game.onReportDismissed(),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFF8B7355), width: 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Text(
                              'DISMISS',
                              style: TextStyle(
                                color: Color(0xFF8B7355),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFFC4A882), thickness: 1),
                    // Incident details
                    Text(
                      'SUBJECT: ${activity.displayName.toUpperCase()}',
                      style: const TextStyle(
                        color: Color(0xFF2A1A0A),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LOCATION: ${npc.parentZone.label}',
                      style: const TextStyle(
                        color: Color(0xFF5A4A3A),
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      'TIME: ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Color(0xFF5A4A3A),
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Color(0xFFC4A882), thickness: 1),
                    const SizedBox(height: 4),
                    const Text(
                      'FILE ASSESSMENT:',
                      style: TextStyle(
                        color: Color(0xFF5A4A3A),
                        fontSize: 10,
                        fontFamily: 'monospace',
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Three stamp options
                    for (final report in activity.reports) ...[
                      _StampButton(
                        level: report.level,
                        text: report.text,
                        onTap: () => game.onReportFiled(report),
                      ),
                      if (report.level < 3) const SizedBox(height: 6),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StampButton extends StatelessWidget {
  final int level;
  final String text;
  final VoidCallback onTap;

  const _StampButton({
    required this.level,
    required this.text,
    required this.onTap,
  });

  Color get _stampColor {
    return switch (level) {
      1 => const Color(0xFF2E6B35),
      2 => const Color(0xFFB8860B),
      3 => const Color(0xFF8B1A1A),
      _ => const Color(0xFF666666),
    };
  }

  String get _levelLabel {
    return switch (level) {
      1 => 'NOTED',
      2 => 'FLAGGED',
      3 => 'ESCALATED',
      _ => '???',
    };
  }

  double get _stampAngle {
    return switch (level) {
      1 => -0.02,
      2 => 0.015,
      3 => -0.03,
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _stampColor.withAlpha(0x0A),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: _stampColor.withAlpha(0x44), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.rotate(
              angle: _stampAngle,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: _stampColor, width: 2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  _levelLabel,
                  style: TextStyle(
                    color: _stampColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: const Color(0xFF2A1A0A).withAlpha(0xBB),
                  fontSize: 11,
                  height: 1.3,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
