import 'dart:math';

import 'package:flutter/material.dart';

import '../data/reports.dart';
import '../game.dart';

/// Between-shift newspaper: Neighbours Weekly.
/// Shows consequences of Gerald's reports as neighborhood stories.
class RoundResultOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const RoundResultOverlay({super.key, required this.game});

  static const _fillerStories = [
    "Mrs. Henderson's roses win garden club award for 3rd year",
    'Maple Drive pothole finally filled after 2-year campaign',
    'Community bake sale raises \$247 for library renovation',
    'Street light on corner of 3rd and Maple now working again',
    "Lost cat found: Mr. Whiskers returns after 2-day adventure",
    'Farmers market adds Thursday hours through September',
    'Maple Drive speed bump petition reaches city council',
    'New bench installed at bus stop, dedicated to longtime resident',
  ];

  String _geraldMood() {
    final consequences = game.shiftReports
        .where((r) => r.report.consequence != null)
        .toList();
    if (consequences.isEmpty) {
      return 'Gerald stares at the blank page of his notebook.';
    }
    final shiftTension =
        game.shiftReports.fold<int>(0, (sum, r) => sum + r.report.tension);
    if (shiftTension <= 6) {
      return "Gerald flips his notebook shut. 'Quiet week.'";
    } else if (shiftTension <= 20) {
      return "Gerald nods slowly. 'Vigilance pays off.'";
    } else if (shiftTension <= 40) {
      return "Gerald's pen hasn't stopped moving.";
    } else {
      return "Gerald's hand trembles as he writes.";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get reports with consequences (non-dismiss choices)
    final consequenceReports = game.shiftReports
        .where((r) => r.report.consequence != null)
        .toList();

    // Pick 1-2 filler stories to mix in
    final rng = Random();
    final fillers = List<String>.from(_fillerStories)..shuffle(rng);
    final fillerCount = consequenceReports.isEmpty ? 3 : (consequenceReports.length <= 2 ? 2 : 1);
    final selectedFillers = fillers.take(fillerCount).toList();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EE),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0xFFAA9977), width: 1.5),
          boxShadow: const [
            BoxShadow(
                color: Color(0x66000000),
                blurRadius: 16,
                offset: Offset(0, 4)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Masthead
              const Text(
                'NEIGHBOURS WEEKLY',
                style: TextStyle(
                  color: Color(0xFF2A1A0A),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 1,
                ),
              ),
              const Text(
                'Maple Drive Edition',
                style: TextStyle(
                  color: Color(0xFF8B7355),
                  fontSize: 9,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
              const Divider(color: Color(0xFF2A1A0A), thickness: 2),
              const SizedBox(height: 6),

              // Consequence headlines from reports
              for (final entry in consequenceReports) ...[
                _StoryItem(
                  headline: entry.report.consequence!,
                  isConsequence: true,
                ),
                const SizedBox(height: 8),
              ],

              // Filler neighborhood stories
              for (final filler in selectedFillers) ...[
                _StoryItem(headline: filler, isConsequence: false),
                const SizedBox(height: 8),
              ],

              if (consequenceReports.isEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'It was a quiet week on Maple Drive.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF7A6A5A),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],

              const Divider(color: Color(0xFFD4C4A2), thickness: 0.5),

              // Gerald's mood
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _geraldMood(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF6A5A4A),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'monospace',
                  ),
                ),
              ),

              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => game.onRoundResultDismissed(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A1A0A),
                  foregroundColor: const Color(0xFFF5E6C8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                child:
                    Text(game.currentRound >= 5 ? 'FINAL EDITION' : 'NEXT WEEK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  final String headline;
  final bool isConsequence;

  const _StoryItem({required this.headline, required this.isConsequence});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: isConsequence
          ? BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: const Color(0xFF8B7355),
                  width: 2,
                ),
              ),
            )
          : null,
      child: Text(
        headline,
        style: TextStyle(
          color: isConsequence
              ? const Color(0xFF2A1A0A)
              : const Color(0xFF9A8A7A),
          fontSize: isConsequence ? 12 : 10,
          fontWeight: isConsequence ? FontWeight.w600 : FontWeight.normal,
          fontFamily: 'monospace',
          height: 1.3,
        ),
      ),
    );
  }
}
