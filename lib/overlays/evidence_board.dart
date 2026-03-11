import 'dart:math';

import 'package:flutter/material.dart';

import '../game.dart';

/// Evidence board overlay — Gerald's conspiracy wall.
/// Displays photographed NPCs as "evidence" with red string connections.
/// Persists across shifts.
class EvidenceBoardOverlay extends StatelessWidget {
  final NeighborhoodWatchGame game;

  const EvidenceBoardOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final photos = game.evidencePhotos;

    return Container(
      color: const Color(0xEE0A0A0A),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  const Text(
                    'EVIDENCE BOARD',
                    style: TextStyle(
                      color: Color(0xFFFF6644),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 3,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${photos.length} PHOTO${photos.length == 1 ? '' : 'S'}',
                    style: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 10,
                      fontFamily: 'monospace',
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => game.closeEvidenceBoard(),
                    child: const Text(
                      '\u00d7',
                      style: TextStyle(
                        color: Color(0xFFAA8877),
                        fontSize: 28,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFF333333), height: 1),

            // Board
            Expanded(
              child: photos.isEmpty
                  ? _buildEmptyBoard()
                  : _buildPhotoGrid(photos),
            ),

            // Hint
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF333333), width: 1),
                ),
              ),
              child: Text(
                photos.isEmpty
                    ? 'Double-tap a subject to photograph them as evidence.'
                    : 'Gerald\'s evidence. The Council will see the truth.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF666655),
                  fontSize: 9,
                  fontFamily: 'monospace',
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyBoard() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\ud83d\udcf7',
            style: TextStyle(fontSize: 48),
          ),
          SizedBox(height: 16),
          Text(
            'NO EVIDENCE COLLECTED',
            style: TextStyle(
              color: Color(0xFF555544),
              fontSize: 12,
              fontFamily: 'monospace',
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Double-tap subjects during your shift\nto add them to the board.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF444433),
              fontSize: 10,
              fontFamily: 'monospace',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(List<EvidencePhoto> photos) {
    return CustomPaint(
      painter: _RedStringPainter(photos.length),
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return _EvidenceCard(photo: photo, index: index);
        },
      ),
    );
  }
}

/// Red string connections between evidence cards.
class _RedStringPainter extends CustomPainter {
  final int count;
  _RedStringPainter(this.count);

  @override
  void paint(Canvas canvas, Size size) {
    if (count < 2) return;

    final paint = Paint()
      ..color = const Color(0x44FF2222)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final rng = Random(42); // Deterministic for consistency
    final cols = 3;
    final cellW = (size.width - 24) / cols;
    final cellH = cellW / 0.75;

    // Draw red strings between some adjacent cards
    for (var i = 0; i < count - 1; i++) {
      if (rng.nextDouble() > 0.6) continue; // Not all connected
      final fromCol = i % cols;
      final fromRow = i ~/ cols;
      final toCol = (i + 1) % cols;
      final toRow = (i + 1) ~/ cols;

      final from =
          Offset(12 + fromCol * cellW + cellW / 2, 12 + fromRow * cellH + cellH / 2);
      final to =
          Offset(12 + toCol * cellW + cellW / 2, 12 + toRow * cellH + cellH / 2);

      canvas.drawLine(from, to, paint);
    }

    // A few diagonal connections for conspiracy vibes
    for (var i = 0; i < count - cols; i++) {
      if (rng.nextDouble() > 0.3) continue;
      final fromCol = i % cols;
      final fromRow = i ~/ cols;
      final toCol = (i + cols) % cols;
      final toRow = (i + cols) ~/ cols;

      final from =
          Offset(12 + fromCol * cellW + cellW / 2, 12 + fromRow * cellH + cellH / 2);
      final to =
          Offset(12 + toCol * cellW + cellW / 2, 12 + toRow * cellH + cellH / 2);

      canvas.drawLine(from, to, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Individual evidence photo card.
class _EvidenceCard extends StatelessWidget {
  final EvidencePhoto photo;
  final int index;

  const _EvidenceCard({required this.photo, required this.index});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: (index.isEven ? 0.02 : -0.02) + (index * 0.005),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9F0),
          border: Border.all(color: const Color(0xFF999888), width: 1),
          boxShadow: const [
            BoxShadow(
                color: Color(0x33000000), blurRadius: 4, offset: Offset(1, 2)),
          ],
        ),
        child: Column(
          children: [
            // "Photo" area — emoji + color block
            Expanded(
              child: Container(
                width: double.infinity,
                color: photo.activity.color.withAlpha(180),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        photo.activity.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SHIFT ${photo.shift + 1}',
                        style: const TextStyle(
                          color: Color(0xBBFFFFFF),
                          fontSize: 7,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Caption
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              child: Text(
                photo.activity.displayName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  color: Color(0xFF3A3020),
                  fontSize: 7,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
