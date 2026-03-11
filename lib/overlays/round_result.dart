import 'package:flutter/material.dart';

import '../data/reports.dart';
import '../game.dart';

/// Between-shift newspaper: MAPLE DRIVE GAZETTE.
/// Shows headlines from the player's reports this shift.
class RoundResultOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const RoundResultOverlay({super.key, required this.game});

  String _geraldMood() {
    if (game.shiftReports.isEmpty) {
      return 'Gerald is... concerned by the lack of concerns.';
    }
    // Sum tension earned this shift
    final shiftTension = game.shiftReports
        .fold<int>(0, (sum, r) => sum + r.report.points);
    if (shiftTension <= 10) {
      return "Gerald yawns. 'Is that really all?'";
    } else if (shiftTension <= 30) {
      return "Gerald nods approvingly. 'Vigilance.'";
    } else {
      return "Gerald's eye twitches. 'They're everywhere.'";
    }
  }

  @override
  Widget build(BuildContext context) {
    final reports = game.shiftReports;
    // Show up to 4 reports
    final displayReports = reports.length > 4 ? reports.sublist(0, 4) : reports;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 440),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EE),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0xFFAA9977), width: 1.5),
          boxShadow: const [
            BoxShadow(color: Color(0x66000000), blurRadius: 16, offset: Offset(0, 4)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Masthead
              const Text(
                'MAPLE DRIVE GAZETTE',
                style: TextStyle(
                  color: Color(0xFF2A1A0A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
              const Text(
                '"All the news Gerald deems suspicious"',
                style: TextStyle(
                  color: Color(0xFF8B7355),
                  fontSize: 9,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'monospace',
                ),
              ),
              const Divider(color: Color(0xFF2A1A0A), thickness: 2),
              const SizedBox(height: 8),

              // Headlines
              if (displayReports.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'A quiet day on Maple Drive.\nSuspiciously quiet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5A4A3A),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'monospace',
                    ),
                  ),
                )
              else
                for (final entry in displayReports) ...[
                  _HeadlineItem(
                    activity: entry.activity,
                    report: entry.report,
                  ),
                  const Divider(color: Color(0xFFD4C4A2), thickness: 0.5),
                ],

              const SizedBox(height: 8),

              // Gerald's mood
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E4D0),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  _geraldMood(),
                  style: const TextStyle(
                    color: Color(0xFF5A4A3A),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'monospace',
                  ),
                ),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => game.onRoundResultDismissed(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A1A0A),
                  foregroundColor: const Color(0xFFF5E6C8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                child: Text(game.currentRound >= 5
                    ? 'FINAL REPORT'
                    : 'NEXT SHIFT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeadlineItem extends StatelessWidget {
  final ActivityData activity;
  final ReportOption report;

  const _HeadlineItem({
    required this.activity,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final isEscalated = report.level == 3;
    final isFlagged = report.level == 2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isEscalated)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              margin: const EdgeInsets.only(bottom: 4),
              color: const Color(0xFF8B1A1A),
              child: const Text(
                'BREAKING',
                style: TextStyle(
                  color: Color(0xFFFFF8EE),
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
            ),
          Text(
            '${activity.emoji} ${activity.displayName.toUpperCase()}',
            style: TextStyle(
              color: const Color(0xFF2A1A0A),
              fontSize: isEscalated ? 13 : (isFlagged ? 12 : 11),
              fontWeight: isEscalated ? FontWeight.bold : (isFlagged ? FontWeight.w600 : FontWeight.normal),
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            report.text,
            style: TextStyle(
              color: isEscalated
                  ? const Color(0xFF5A2A1A)
                  : const Color(0xFF7A6A5A),
              fontSize: 10,
              fontFamily: 'monospace',
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
