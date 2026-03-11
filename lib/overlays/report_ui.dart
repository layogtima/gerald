import 'package:flutter/material.dart';

import '../data/reports.dart';
import '../game.dart';

/// Clipboard-style report UI with 4 internal-monologue choices.
/// No severity labels visible — player picks by gut feeling.
class ReportUiOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const ReportUiOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final npc = game.observedNpc;
    if (npc == null) return const SizedBox.shrink();

    final activity = npc.activityData;

    // Shuffle choices so player can't learn position = severity
    final shuffled = List<ReportOption>.from(activity.reports)..shuffle();

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.55,
            maxWidth: 440,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF0),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFBBB094), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 20,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Clipboard clip
                Container(
                  width: 80,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B8070),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(4),
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Subject header + close X
                          Row(
                            children: [
                              Text(
                                '${activity.emoji} ${activity.displayName}',
                                style: const TextStyle(
                                  color: Color(0xFF3A2A1A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => game.onReportDismissed(),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    '\u00d7',
                                    style: TextStyle(
                                      color: Color(0xFF999080),
                                      fontSize: 20,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Color(0xFFD4C4A8),
                            thickness: 0.5,
                            height: 12,
                          ),
                          // 4 choices
                          for (final report in shuffled) ...[
                            _ChoiceTile(
                              text: report.text,
                              onTap: () => game.onReportFiled(report),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _ChoiceTile({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFFE8DDD0),
              width: 0.5,
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF4A3A2A),
            fontSize: 13,
            fontFamily: 'monospace',
            fontStyle: FontStyle.italic,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}
