import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

class StepItem {
  const StepItem(this.title, this.subtitle, this.color);

  final String title;
  final String subtitle;
  final Color color;
}

/// Numbered steps joined by one winding line, alternating sides.
///
/// With [activeIndex] null every step is coloured and [progress] (0..1) draws
/// the line gradually. With [activeIndex] set, steps up to it are coloured and
/// the rest are grey, which is how a request's status is shown.
class WindingSteps extends StatelessWidget {
  const WindingSteps({
    super.key,
    required this.steps,
    this.activeIndex,
    this.progress = 1,
    this.rowHeight = 100,
  });

  final List<StepItem> steps;
  final int? activeIndex;
  final double progress;
  final double rowHeight;

  static const double _edge = 30;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final n = steps.length;

        bool onRight(int i) => rtl ? i.isEven : i.isOdd;
        Offset center(int i) => Offset(
          onRight(i) ? w - _edge : _edge,
          rowHeight * i + rowHeight / 2,
        );

        bool reached(int i) => activeIndex == null || i <= activeIndex!;
        bool shown(int i) =>
            activeIndex != null || progress * (n - 1) >= i - 0.2;

        return SizedBox(
          width: w,
          height: rowHeight * n,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _LinePainter(
                    points: [for (var i = 0; i < n; i++) center(i)],
                    activeIndex: activeIndex,
                    progress: progress,
                  ),
                ),
              ),
              for (var i = 0; i < n; i++) ...[
                Positioned(
                  top: rowHeight * i,
                  height: rowHeight,
                  left: onRight(i) ? 8 : _edge * 2 + 12,
                  right: onRight(i) ? _edge * 2 + 12 : 8,
                  child: AnimatedOpacity(
                    opacity: shown(i) ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          steps[i].title,
                          textAlign: onRight(i)
                              ? TextAlign.right
                              : TextAlign.left,
                          style: text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: reached(i)
                                ? AppColors.deep
                                : AppColors.muted,
                          ),
                        ),
                        Text(
                          steps[i].subtitle,
                          textAlign: onRight(i)
                              ? TextAlign.right
                              : TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall?.copyWith(
                            color: AppColors.muted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: center(i).dx - 24,
                  top: center(i).dy - 24,
                  child: AnimatedScale(
                    scale: shown(i) ? 1 : 0.4,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutBack,
                    child: AnimatedOpacity(
                      opacity: shown(i) ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: StepCircle(
                        number: i + 1,
                        color: reached(i) ? steps[i].color : AppColors.line,
                        done: activeIndex != null && i < activeIndex!,
                        dimmed: !reached(i),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class StepCircle extends StatelessWidget {
  const StepCircle({
    super.key,
    required this.number,
    required this.color,
    this.done = false,
    this.dimmed = false,
  });

  final int number;
  final Color color;
  final bool done;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: dimmed ? AppColors.muted : AppColors.deep,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: done
            ? const Icon(Icons.check_rounded, size: 18, color: AppColors.white)
            : Text(
                '$number',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.1,
                ),
              ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({
    required this.points,
    required this.activeIndex,
    required this.progress,
  });

  final List<Offset> points;
  final int? activeIndex;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final segments = points.length - 1;
    for (var i = 0; i < segments; i++) {
      final a = points[i];
      final b = points[i + 1];
      final k = (b.dy - a.dy) * 0.5;
      var path = Path()
        ..moveTo(a.dx, a.dy)
        ..cubicTo(a.dx, a.dy + k, b.dx, b.dy - k, b.dx, b.dy);

      if (activeIndex == null) {
        paint.color = AppColors.light;
        final local = min(1.0, max(0.0, progress * segments - i));
        if (local <= 0) continue;
        if (local < 1) {
          final metric = path.computeMetrics().first;
          path = metric.extractPath(0, metric.length * local);
        }
      } else {
        paint.color = i < activeIndex! ? AppColors.brand : AppColors.line;
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.activeIndex != activeIndex ||
      oldDelegate.points.length != points.length ||
      (points.isNotEmpty && oldDelegate.points.first != points.first);
}
