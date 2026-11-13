import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../data/models.dart';
import '../theme/app_colors.dart';

/// Drawn placeholder for a work photo, one simple pattern per trade.
/// Swap for a real image once photo upload exists.
class WorkArt extends StatelessWidget {
  const WorkArt({super.key, required this.trade, this.seed = 0});

  final Trade trade;
  final int seed;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        painter: _ArtPainter(trade, seed),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ArtPainter extends CustomPainter {
  _ArtPainter(this.trade, this.seed);

  final Trade trade;
  final int seed;

  @override
  void paint(Canvas canvas, Size s) {
    final rnd = Random(seed * 31 + trade.index);
    final fill = Paint();
    Paint stroke(Color color, double width) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawRect(Offset.zero & s, fill..color = AppColors.surface);

    switch (trade) {
      case Trade.tiling:
        final cell = s.width / 7;
        const cols = [
          AppColors.light,
          AppColors.white,
          AppColors.surface,
          AppColors.yellow,
        ];
        for (var y = 0.0; y < s.height; y += cell) {
          for (var x = 0.0; x < s.width; x += cell) {
            final r = rnd.nextInt(10);
            fill.color = cols[r < 4 ? 0 : (r < 7 ? 1 : (r < 9 ? 2 : 3))];
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(x + 2, y + 2, cell - 4, cell - 4),
                const Radius.circular(4),
              ),
              fill,
            );
          }
        }
      case Trade.carpentry:
        final h = s.height / 5;
        final grain = stroke(const Color(0xFFA9824F), 2);
        for (var i = 0; i < 5; i++) {
          fill.color = i.isEven
              ? const Color(0xFFD8B98C)
              : const Color(0xFFC9A676);
          canvas.drawRect(Rect.fromLTWH(0, i * h, s.width, h - 2), fill);
          final gx = rnd.nextDouble() * s.width;
          canvas.drawLine(Offset(gx, i * h), Offset(gx, i * h + h - 2), grain);
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset((gx + s.width * 0.4) % s.width, i * h + h / 2),
              width: 18,
              height: 7,
            ),
            grain,
          );
        }
      case Trade.painting:
        final w = s.width / 6;
        const cols = [AppColors.orange, AppColors.lilac, AppColors.yellow];
        fill.color = cols[seed % cols.length];
        for (var i = 0; i < 6; i++) {
          final hh = s.height * (0.45 + rnd.nextDouble() * 0.45);
          canvas.drawRRect(
            RRect.fromRectAndCorners(
              Rect.fromLTWH(i * w, 0, w + 1, hh),
              bottomLeft: Radius.circular(w / 2),
              bottomRight: Radius.circular(w / 2),
            ),
            fill,
          );
        }
      case Trade.electric:
        final wire = stroke(AppColors.brand, 4);
        final ring = stroke(AppColors.deep, 3);
        for (var i = 0; i < 4; i++) {
          final y = s.height * (0.2 + i * 0.2);
          final bend = s.width * (0.25 + rnd.nextDouble() * 0.5);
          final dy = (i.isEven ? 1 : -1) * s.height * 0.1;
          canvas.drawPath(
            Path()
              ..moveTo(0, y)
              ..lineTo(bend, y)
              ..lineTo(bend + 20, y + dy)
              ..lineTo(s.width, y + dy),
            wire,
          );
          canvas.drawCircle(Offset(bend, y), 7, fill..color = AppColors.yellow);
          canvas.drawCircle(Offset(bend, y), 7, ring);
        }
      case Trade.plumbing:
        final x1 = s.width * (0.25 + rnd.nextDouble() * 0.2);
        final x2 = s.width * (0.6 + rnd.nextDouble() * 0.2);
        canvas.drawPath(
          Path()
            ..moveTo(0, s.height * 0.3)
            ..lineTo(x1, s.height * 0.3)
            ..lineTo(x1, s.height * 0.72)
            ..lineTo(s.width, s.height * 0.72),
          stroke(AppColors.light, 18),
        );
        canvas.drawPath(
          Path()
            ..moveTo(x2, 0)
            ..lineTo(x2, s.height * 0.45)
            ..lineTo(s.width, s.height * 0.45),
          stroke(AppColors.brand, 18),
        );
        fill.color = AppColors.orange;
        for (final o in [
          Offset(x1, s.height * 0.3),
          Offset(x1, s.height * 0.72),
          Offset(x2, s.height * 0.45),
        ]) {
          canvas.drawCircle(o, 13, fill);
        }
      case Trade.ac:
        final unit = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            s.width * 0.15,
            s.height * 0.14,
            s.width * 0.7,
            s.height * 0.3,
          ),
          const Radius.circular(16),
        );
        canvas.drawRRect(unit, fill..color = AppColors.white);
        final outline = stroke(AppColors.deep, 3);
        canvas.drawRRect(unit, outline);
        canvas.drawLine(
          Offset(s.width * 0.22, s.height * 0.36),
          Offset(s.width * 0.78, s.height * 0.36),
          outline,
        );
        final air = stroke(AppColors.lilac, 5);
        for (var i = 0; i < 3; i++) {
          final x = s.width * (0.3 + i * 0.2);
          canvas.drawPath(
            Path()
              ..moveTo(x, s.height * 0.54)
              ..cubicTo(
                x - 18,
                s.height * 0.66,
                x + 18,
                s.height * 0.74,
                x,
                s.height * 0.88,
              ),
            air,
          );
        }
    }
  }

  @override
  bool shouldRepaint(_ArtPainter oldDelegate) =>
      oldDelegate.trade != trade || oldDelegate.seed != seed;
}
