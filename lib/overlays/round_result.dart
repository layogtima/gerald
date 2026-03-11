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

    // Observations woven into letter prose
    final filed = reports.where((r) => r.report.tension > 0).toList();
    final dismissed = reports.where((r) => r.report.tension == 0).toList();

    if (filed.isEmpty && dismissed.isNotEmpty) {
      buf.writeln(
          'I watched the street for the full duration of my shift. '
          'Nothing struck me as unusual. Neighbors came and went. '
          'It was all perfectly ordinary, which, I must confess, '
          'I find the most unsettling outcome of all.');
    } else if (filed.isEmpty) {
      buf.writeln(
          'The street was quiet tonight. No one came out. '
          'No lights, no movement. I don\'t know what that means '
          'but I felt I should note it.');
    } else {
      // Weave each observation into natural prose
      for (int i = 0; i < filed.length; i++) {
        final r = filed[i];
        final name = r.activity.displayName.toLowerCase();
        final assessment = r.report.text;

        if (i == 0 && tension < 40) {
          buf.write('I noticed a resident $name today. ');
          buf.writeln('My assessment: $assessment');
        } else if (i == 0 && tension < 70) {
          buf.write(
              'First, and I want this on record \u2014 '
              'I observed a resident $name. ');
          buf.writeln(assessment);
        } else if (i == 0) {
          buf.write(
              'Let me get straight to it. '
              'A resident was seen $name. ');
          buf.writeln(assessment);
        } else if (tension < 50) {
          buf.write(
              'I also saw someone $name. ');
          buf.writeln(assessment);
        } else {
          buf.write(
              'There\'s more. Another resident, $name. ');
          buf.writeln(assessment);
        }

        if (r.report.consequence != null) {
          if (tension < 40) {
            buf.writeln(
                'I believe the appropriate response would be: '
                '${r.report.consequence}.');
          } else if (tension < 70) {
            buf.writeln(
                'The Council should consider action. '
                'Specifically: ${r.report.consequence}.');
          } else {
            buf.writeln(
                'Something has to be done. '
                '${r.report.consequence}. Please.');
          }
        }
        buf.writeln();
      }

      // Mention dismissed observations naturally
      if (dismissed.isNotEmpty) {
        if (dismissed.length == 1) {
          buf.writeln(
              'I also observed a resident '
              '${dismissed.first.activity.displayName.toLowerCase()}, '
              'but it didn\'t seem worth reporting. '
              'At least, not yet.');
        } else {
          buf.writeln(
              'There were ${dismissed.length} other residents out '
              'who didn\'t warrant a formal report. '
              'I\'m keeping notes regardless.');
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
    final pool = <String>[];

    if (shift == 0) {
      return 'I am writing to confirm that surveillance operations '
          'have commenced as scheduled. The street appears calm.';
    }

    if (shift <= 2 && tension < 30) {
      pool.addAll([
        'I am pleased to report another productive shift. '
            'The following observations have been documented for your records.',
        'The street remains under careful observation. '
            'I have several items to note from this shift.',
        'As always, I begin my report with an assurance that '
            'the situation remains under control. Mostly.',
      ]);
    } else if (shift <= 4 && tension < 50) {
      pool.addAll([
        'I must bring several matters to your attention. '
            'Activity on the street has become irregular.',
        'I hesitated before writing this letter. '
            'But the Council deserves to know what I have observed.',
        'This shift was different. I am not sure how to explain it, '
            'but I will try my best.',
      ]);
    } else if (tension < 70) {
      pool.addAll([
        'I need to be frank with the Council. '
            'Things on this street are not what they appear to be.',
        'I have been going over my notes from previous shifts. '
            'The pattern is unmistakable.',
        'Before I begin, I want the Council to know that I am of sound mind. '
            'What I am about to describe is real.',
        'I considered not writing this letter. '
            'But silence would be a disservice to the truth.',
      ]);
    } else if (tension < 100) {
      pool.addAll([
        'I don\'t know how else to say this. '
            'Something is happening on this street. '
            'I am documenting everything I can before it\'s too late.',
        'I have barricaded the door. Not out of fear \u2014 out of necessity. '
            'I need uninterrupted time to write this letter.',
        'The streetlights flickered three times before this shift began. '
            'I am choosing to interpret this as encouragement.',
        'I have run out of notebooks. '
            'I am writing on the back of grocery receipts now. '
            'The Council will understand.',
      ]);
    } else {
      pool.addAll([
        'They know I\'m writing this. '
            'I can see them looking at my window right now. '
            'Please read this carefully.',
        'This may be my last letter. Or it may not. '
            'I have lost the ability to predict what happens next.',
        'I am writing this in the dark because the lights attract attention. '
            'Forgive any typos.',
        'I no longer sleep. Sleep is when they reorganize. '
            'I have been watching continuously for... I am not sure how long.',
        'The binoculars have become part of my face. '
            'I don\'t mean that metaphorically.',
      ]);
    }

    return pool[shift % pool.length];
  }

  String _getClosing(int shift, int tension) {
    final pool = <String>[];

    if (shift == 0) {
      return 'I look forward to a long and productive partnership '
          'with the Council. The street is in good hands.';
    }

    if (tension < 25) {
      pool.addAll([
        'I trust the Council will take appropriate action. '
            'I remain at my post.',
        'All in all, a satisfactory shift. '
            'I expect the next one will be equally uneventful.',
        'The street sleeps. And so, shortly, will I. '
            'But the binoculars will be ready at dawn.',
      ]);
    } else if (tension < 50) {
      pool.addAll([
        'I await your guidance on these matters. '
            'The situation may require additional resources.',
        'I would appreciate any feedback on my methods. '
            'I want to ensure my reports meet the Council\'s standards.',
        'If the Council could send someone to verify my findings, '
            'I would welcome the company. And the validation.',
      ]);
    } else if (tension < 75) {
      pool.addAll([
        'I urge the Council to review these findings immediately. '
            'I am beginning to notice patterns that concern me deeply.',
        'I have attached a diagram to this letter. '
            'It is drawn on the back. The connections speak for themselves.',
        'I am not asking for reassurance. I am asking for acknowledgment '
            'that someone, somewhere, is paying attention.',
      ]);
    } else if (tension < 100) {
      pool.addAll([
        'Has the Council received my previous letters? '
            'I have not received a response. '
            'Please confirm that someone is reading these.',
        'I have started numbering my letters. This is number ${shift + 1}. '
            'If any are missing from the Council\'s records, we have a problem.',
        'The mailbox has started to feel like a one-way mirror. '
            'I put letters in. Nothing comes out. '
            'But someone is collecting them. I can tell.',
      ]);
    } else {
      pool.addAll([
        'I no longer know if the Council exists. '
            'I am writing this for the record. '
            'If you find this letter, know that Gerald tried.',
        'Perhaps the letters themselves are the point. '
            'Perhaps writing is the watching, and watching is the writing. '
            'I have confused myself.',
        'I will keep writing. Not because anyone is reading, '
            'but because someone should be.',
        'The street outside my window is the same street it has always been. '
            'Or is it? I have written too many letters to remember.',
      ]);
    }

    return pool[shift % pool.length];
  }
}
