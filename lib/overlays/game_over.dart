import 'package:flutter/material.dart';

import '../game.dart';

/// Game over overlay — Gerald's final letter + stats + ending.
class GameOverOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final isDeadEnd = game.lastDeadEnd != null;
    final shiftsCompleted = game.currentRound;
    final reportsTotal = game.allReports.length;
    final tension = game.tension;

    final String title;
    final String stampText;
    final Color stampColor;

    if (isDeadEnd) {
      title = 'END OF WATCH';
      stampText = 'CASE CLOSED';
      stampColor = const Color(0xFF8B1A1A);
    } else {
      title = 'THE WATCHER RESTS';
      stampText = 'RETIRED';
      stampColor = const Color(0xFF607D8B);
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 440, maxHeight: 620),
        decoration: BoxDecoration(
          color: const Color(0xFFF5E6C8),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0xFF8B7355), width: 1.5),
          boxShadow: const [
            BoxShadow(
                color: Color(0x66000000),
                blurRadius: 16,
                offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'OFFICIAL NOTICE',
              style: TextStyle(
                color: Color(0xFF2A1A0A),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 3,
              ),
            ),
            const Divider(color: Color(0xFFC4A882), thickness: 1),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF2A1A0A),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),

            // Ending narrative or final letter
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isDeadEnd) ...[
                      Text(
                        game.lastDeadEnd!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF5A4A3A),
                          fontSize: 12,
                          fontFamily: 'monospace',
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Gerald's final letter
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9F0),
                        border: Border.all(
                            color: const Color(0xFFD4C4A8), width: 0.5),
                      ),
                      child: Text(
                        _buildFinalLetter(
                            shiftsCompleted, reportsTotal, tension, isDeadEnd),
                        style: const TextStyle(
                          color: Color(0xFF3A3020),
                          fontSize: 10,
                          fontFamily: 'monospace',
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Consequence headlines from the whole game
                    if (game.allReports.isNotEmpty) ...[
                      _buildHeadlines(),
                      const SizedBox(height: 8),
                    ],

                    // Stats
                    Text(
                      'Shifts: $shiftsCompleted  |  Reports: $reportsTotal  |  Tension: $tension',
                      style: const TextStyle(
                        color: Color(0xFF8A7A6A),
                        fontSize: 9,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            Transform.rotate(
              angle: -0.06,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: stampColor, width: 3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  stampText,
                  style: TextStyle(
                    color: stampColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => game.returnToMenu(),
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
              child: const Text('BACK TO MENU'),
            ),
          ],
        ),
      ),
    );
  }

  /// Gerald's farewell letter summarizing the whole watch.
  String _buildFinalLetter(
      int shifts, int reports, int tension, bool isDeadEnd) {
    final buf = StringBuffer();

    if (tension < 30) {
      buf.writeln('Dear Council,');
      buf.writeln();
      buf.writeln(
          'My watch has concluded. Over the course of $shifts shift${shifts == 1 ? '' : 's'}, '
          'I filed $reports report${reports == 1 ? '' : 's'}. '
          'The street remains, to my knowledge, intact.');
      buf.writeln();
      buf.writeln(
          'I believe my service has been adequate. Perhaps even commendable. '
          'I look forward to my next assignment.');
      buf.writeln();
      buf.write('Yours in vigilance,\nGerald');
    } else if (tension < 60) {
      buf.writeln('To the Council,');
      buf.writeln();
      buf.writeln(
          'After $shifts shifts and $reports reports, '
          'I must confess that this street has proven '
          'more complex than initially anticipated. '
          'There are things happening here that I cannot fully explain.');
      buf.writeln();
      buf.writeln(
          'I trust you have been reading my correspondence. '
          'I trust you will act on what I have documented. '
          'I trust the Council.');
      buf.writeln();
      buf.write('Respectfully,\nGerald');
    } else if (tension < 90) {
      buf.writeln('Council \u2014');
      buf.writeln();
      buf.writeln(
          'I have watched this street for $shifts shifts. '
          'I have filed $reports reports. Not one response. '
          'Not a single acknowledgment.');
      buf.writeln();
      buf.writeln(
          'I know what I have seen. The evidence is clear. '
          'Something is deeply wrong with this street, '
          'and I appear to be the only person who cares enough to notice.');
      buf.writeln();
      if (isDeadEnd) {
        buf.writeln(
            'Perhaps it was always going to end this way. '
            'The watcher, watched. The reporter, reported.');
      } else {
        buf.writeln(
            'My binoculars are on the windowsill. '
            'I\'m stepping away. But I\'ll be back.');
      }
      buf.writeln();
      buf.write('Gerald\n(please respond)');
    } else {
      buf.writeln('To whoever finds this,');
      buf.writeln();
      buf.writeln(
          '$shifts shifts. $reports reports. '
          'Every one of them true. Every one of them ignored.');
      buf.writeln();
      buf.writeln(
          'The street is not what it appears to be. '
          'I have seen things that cannot be explained by '
          'conventional neighborhood dynamics. '
          'The Council either does not exist or does not care. '
          'Either way, the street remains unwatched.');
      buf.writeln();
      if (isDeadEnd) {
        buf.writeln(
            'I regret nothing. Someone had to watch. '
            'Someone had to write it down. '
            'If you are reading this, you are the new Gerald.');
      } else {
        buf.writeln(
            'I am putting down the binoculars. '
            'Not because the street is safe. '
            'Because I no longer know if I am.');
      }
      buf.writeln();
      buf.write('Gerald\n(is anyone reading these?)');
    }

    return buf.toString();
  }

  /// Build scrolling headline ticker from consequences of all reports.
  Widget _buildHeadlines() {
    final consequences = game.allReports
        .where((r) => r.report.consequence != null)
        .map((r) => r.report.consequence!)
        .toList();

    if (consequences.isEmpty) return const SizedBox.shrink();

    // Show up to 5 most recent consequences
    final shown = consequences.length > 5
        ? consequences.sublist(consequences.length - 5)
        : consequences;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1A0A),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NEIGHBOURHOOD GAZETTE',
            style: TextStyle(
              color: Color(0xFFAA9977),
              fontSize: 7,
              fontFamily: 'monospace',
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          for (final headline in shown) ...[
            Text(
              '\u2022 $headline',
              style: const TextStyle(
                color: Color(0xFFDDCC99),
                fontSize: 8,
                fontFamily: 'monospace',
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
