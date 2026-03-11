import 'dart:math';

import 'package:flutter/material.dart';

import '../data/reports.dart';
import '../game.dart';

/// Between-shift newspaper: broadsheet style.
/// Shows consequences of Gerald's reports as neighborhood news articles.
class RoundResultOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const RoundResultOverlay({super.key, required this.game});

  /// Shift-specific narrative filler stories that build the arc.
  static const _shiftFillers = <int, List<String>>{
    0: [
      'Maple Drive Celebrates 500 Days Without Incident',
      'Annual Block Party Draws Record Attendance',
      'Community Garden Yields Best Tomatoes in Years',
      'Library Reading Program Enrolls 40 Children This Summer',
      'Street Resurfacing Project Completed Ahead of Schedule',
    ],
    1: [
      'Residents Report Unfamiliar Faces at Weekend Farmers Market',
      'Power Outage Affects Three Homes; Cause Unknown',
      'Stray Cat Population Growing, Says Animal Control',
      'Late-Night Delivery Truck Spotted on Residential Streets',
      'Maple Drive Wi-Fi Networks Experience Intermittent Disruption',
    ],
    2: [
      'HOA Meeting Attendance Triples Amid Growing Concerns',
      'Real Estate Agent Spotted Photographing Properties',
      'Three Families Install Security Systems in One Week',
      'Anonymous Letter Found in Multiple Mailboxes',
      'Maple Drive Residents Form Unofficial Communication Network',
    ],
    3: [
      'Neighborhood Watch Reports Up 300% This Quarter',
      'Council Member Calls for Emergency Community Meeting',
      'Streetlights Upgraded to Brighter Bulbs by Unanimous Vote',
      'Local Man Purchases Sixth Pair of Binoculars This Year',
      'Property Values on Maple Drive Shift Amid Surveillance Debate',
    ],
    4: [
      'Petition to Dissolve Neighborhood Watch Gains Signatures',
      '"Who Watches the Watchman?" Spray-Painted on Sidewalk',
      'Three Residents File Formal Complaints About Being Observed',
      'Local News Crew Spotted on Maple Drive; Story Unknown',
      'Maple Drive Ranked "Most Reported Street" in Tri-County Area',
    ],
    5: [
      'Every Resident on Maple Drive Now Owns Binoculars',
      'Council Votes to Review All Reports Filed This Year',
      'Former Neighbors Return to "See What All the Fuss Is About"',
      'Maple Drive Listed as Case Study in Suburban Sociology Journal',
      'Block Party Cancelled; Replaced by "Mutual Observation Event"',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final consequenceReports = game.shiftReports
        .where((r) => r.report.consequence != null)
        .toList();

    final rng = Random();
    final shift = game.currentRound;
    final fillers = List<String>.from(_shiftFillers[shift] ?? _shiftFillers[0]!)
      ..shuffle(rng);
    final fillerCount =
        consequenceReports.isEmpty ? 3 : (consequenceReports.length <= 2 ? 2 : 1);
    final selectedFillers = fillers.take(fillerCount).toList();

    // Build article body snippets for consequences
    final articles = consequenceReports.map((entry) {
      return _Article(
        headline: entry.report.consequence!,
        body: _generateBody(entry.activity, entry.report),
        isConsequence: true,
      );
    }).toList();

    // Add filler articles
    for (final filler in selectedFillers) {
      articles.add(_Article(
        headline: filler,
        body: null,
        isConsequence: false,
      ));
    }

    final weekNum = shift + 1;
    final isLastShift = shift >= 5;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EE),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0xFF2A1A0A), width: 2),
          boxShadow: const [
            BoxShadow(
                color: Color(0x88000000),
                blurRadius: 20,
                offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Masthead
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF2A1A0A), width: 3),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'NEIGHBOURS WEEKLY',
                    style: TextStyle(
                      color: Color(0xFF2A1A0A),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    height: 1,
                    color: const Color(0xFF2A1A0A),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vol. XLII No. $weekNum',
                        style: const TextStyle(
                          color: Color(0xFF6A5A4A),
                          fontSize: 9,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        'WEEK $weekNum',
                        style: const TextStyle(
                          color: Color(0xFF6A5A4A),
                          fontSize: 9,
                          fontFamily: 'monospace',
                          letterSpacing: 2,
                        ),
                      ),
                      const Text(
                        'Price: Free',
                        style: TextStyle(
                          color: Color(0xFF6A5A4A),
                          fontSize: 9,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Articles
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (consequenceReports.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            'A quiet week. Nothing to report.',
                            style: TextStyle(
                              color: Color(0xFF8A7A6A),
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                    for (int i = 0; i < articles.length; i++) ...[
                      articles[i],
                      if (i < articles.length - 1)
                        Container(
                          height: 1,
                          color: const Color(0xFFD4C4A2),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                        ),
                    ],
                  ],
                ),
              ),
            ),

            // Footer with button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF2A1A0A), width: 1),
                ),
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: () => game.onRoundResultDismissed(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A1A0A),
                    foregroundColor: const Color(0xFFFFF8EE),
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
                  child: Text(isLastShift ? 'FINAL EDITION' : 'NEXT WEEK'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Generate a short body paragraph for a consequence article.
  String _generateBody(ActivityData activity, ReportOption report) {
    final tension = report.tension;
    if (tension <= 2) {
      return 'Residents expressed mild concern following the incident. '
          'The matter is expected to resolve quietly.';
    } else if (tension <= 5) {
      return 'Officials confirmed they received the report and are reviewing '
          'the situation. Additional measures may follow pending investigation.';
    } else {
      return 'The report triggered an immediate response from local authorities. '
          'Neighbors have been advised to remain vigilant as the investigation continues.';
    }
  }
}

class _Article extends StatelessWidget {
  final String headline;
  final String? body;
  final bool isConsequence;

  const _Article({
    required this.headline,
    required this.body,
    required this.isConsequence,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline.toUpperCase(),
          style: TextStyle(
            color: isConsequence
                ? const Color(0xFF2A1A0A)
                : const Color(0xFF7A6A5A),
            fontSize: isConsequence ? 14 : 11,
            fontWeight: isConsequence ? FontWeight.w800 : FontWeight.w600,
            fontFamily: 'monospace',
            height: 1.2,
          ),
        ),
        if (body != null) ...[
          const SizedBox(height: 4),
          Text(
            body!,
            style: const TextStyle(
              color: Color(0xFF5A4A3A),
              fontSize: 10,
              fontFamily: 'monospace',
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
