import 'package:flutter/material.dart';

import '../data/reports.dart';
import '../game.dart';

/// Between-shift overlay: Gerald's letter to the Council.
/// Typewriter aesthetic. References the player's actual choices.
/// Tone escalates with shift count and tension.
class RoundResultOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const RoundResultOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final shift = game.currentRound;
    final tension = game.tension;
    final reports = game.shiftReports;

    final letter = _buildLetter(shift, tension, reports);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 580),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9F0),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0xFFD4C4A8), width: 1),
          boxShadow: const [
            BoxShadow(
                color: Color(0x66000000),
                blurRadius: 20,
                offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header stamp
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFD4C4A8), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CORRESPONDENCE',
                    style: TextStyle(
                      color: Color(0xFFAA9988),
                      fontSize: 9,
                      fontFamily: 'monospace',
                      letterSpacing: 3,
                    ),
                  ),
                  Text(
                    'SHIFT ${shift + 1}',
                    style: const TextStyle(
                      color: Color(0xFFAA9988),
                      fontSize: 9,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),

            // Letter body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Text(
                  letter,
                  style: const TextStyle(
                    color: Color(0xFF3A3020),
                    fontSize: 12,
                    fontFamily: 'monospace',
                    height: 1.6,
                  ),
                ),
              ),
            ),

            // Continue button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFD4C4A8), width: 1),
                ),
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: () => game.onRoundResultDismissed(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A3020),
                    foregroundColor: const Color(0xFFFFF9F0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 1,
                    ),
                  ),
                  child: const Text('NEXT SHIFT'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildLetter(
    int shift,
    int tension,
    List<({ActivityData activity, ReportOption report})> reports,
  ) {
    final buf = StringBuffer();

    // Salutation — degrades with tension
    if (tension < 20) {
      buf.writeln('Dear Council,');
    } else if (tension < 50) {
      buf.writeln('To the Council,');
    } else if (tension < 80) {
      buf.writeln('Council \u2014');
    } else {
      buf.writeln('To whoever is reading this,');
    }
    buf.writeln();

    // Opening line — varies by shift and tension
    buf.writeln(_getOpening(shift, tension));
    buf.writeln();

    // Observations from this shift
    final filedReports =
        reports.where((r) => r.report.tension > 0).toList();
    if (filedReports.isEmpty) {
      buf.writeln(
          'I observed nothing of concern during this shift. '
          'The street was quiet. Perhaps too quiet.');
    } else {
      for (int i = 0; i < filedReports.length; i++) {
        final r = filedReports[i];
        buf.writeln(
            'OBSERVATION ${i + 1}: Subject seen '
            '${r.activity.displayName.toLowerCase()}. '
            'Assessment: "${r.report.text}"');
        if (r.report.consequence != null) {
          buf.writeln('  \u2192 Recommended action: ${r.report.consequence}');
        }
        buf.writeln();
      }
    }

    // Closing — escalates
    buf.writeln(_getClosing(shift, tension));
    buf.writeln();

    // Signature — degrades
    if (tension < 30) {
      buf.write('Yours in vigilance,\nGerald');
    } else if (tension < 60) {
      buf.write('Respectfully,\nGerald');
    } else if (tension < 90) {
      buf.write('Gerald\n(please respond)');
    } else {
      buf.write('Gerald\n(is anyone reading these?)');
    }

    return buf.toString();
  }

  String _getOpening(int shift, int tension) {
    if (shift == 0) {
      return 'I am writing to confirm that surveillance operations '
          'have commenced as scheduled. The street appears calm.';
    } else if (shift <= 2 && tension < 30) {
      return 'I am pleased to report another productive shift. '
          'The following observations have been documented for your records.';
    } else if (shift <= 4 && tension < 50) {
      return 'I must bring several matters to your attention. '
          'Activity on the street has become irregular.';
    } else if (tension < 70) {
      return 'I need to be frank with the Council. '
          'Things on this street are not what they appear to be. '
          'I have documented the following.';
    } else if (tension < 100) {
      return 'I don\'t know how else to say this. '
          'Something is happening on this street. '
          'I am documenting everything I can before it\'s too late.';
    } else {
      return 'They know I\'m writing this. '
          'I can see them looking at my window right now. '
          'Please read this carefully.';
    }
  }

  String _getClosing(int shift, int tension) {
    if (shift == 0) {
      return 'I look forward to a long and productive partnership '
          'with the Council. The street is in good hands.';
    } else if (tension < 25) {
      return 'I trust the Council will take appropriate action. '
          'I remain at my post.';
    } else if (tension < 50) {
      return 'I await your guidance on these matters. '
          'The situation may require additional resources.';
    } else if (tension < 75) {
      return 'I urge the Council to review these findings immediately. '
          'I am beginning to notice patterns that concern me deeply.';
    } else if (tension < 100) {
      return 'Has the Council received my previous letters? '
          'I have not received a response. '
          'Please confirm that someone is reading these.';
    } else {
      return 'I no longer know if the Council exists. '
          'I am writing this for the record. '
          'If you find this letter, know that Gerald tried.';
    }
  }
}
