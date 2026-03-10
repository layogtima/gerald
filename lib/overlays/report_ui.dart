import 'package:flutter/material.dart';

import '../game.dart';

class ReportUiOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const ReportUiOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final npc = game.observedNpc;
    if (npc == null) return const SizedBox.shrink();

    final activity = npc.activityData;

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            maxWidth: 600,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xF0F5F0DC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF8B7355), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(Icons.assignment,
                          color: Color(0xFF4A3728), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'INCIDENT REPORT: ${activity.displayName.toUpperCase()}',
                          style: const TextStyle(
                            color: Color(0xFF4A3728),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => game.onReportDismissed(),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.close,
                              color: Color(0xFF8B7355), size: 22),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF8B7355)),
                  // Three report options
                  for (final report in activity.reports) ...[
                    _ReportButton(
                      level: report.level,
                      text: report.text,
                      points: report.points,
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
    );
  }
}

class _ReportButton extends StatelessWidget {
  final int level;
  final String text;
  final int points;
  final VoidCallback onTap;

  const _ReportButton({
    required this.level,
    required this.text,
    required this.points,
    required this.onTap,
  });

  Color get _bgColor {
    return switch (level) {
      1 => const Color(0xFFE8F5E9),
      2 => const Color(0xFFFFF3E0),
      3 => const Color(0xFFFFEBEE),
      _ => const Color(0xFFEEEEEE),
    };
  }

  Color get _borderColor {
    return switch (level) {
      1 => const Color(0xFF4CAF50),
      2 => const Color(0xFFFF9800),
      3 => const Color(0xFFF44336),
      _ => const Color(0xFF9E9E9E),
    };
  }

  String get _levelLabel {
    return switch (level) {
      1 => 'MILD',
      2 => 'SUSPICIOUS',
      3 => 'UNHINGED',
      _ => '???',
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
          color: _bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _borderColor, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _borderColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                _levelLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '+$points',
              style: TextStyle(
                color: _borderColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
