import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

/// A soft, slightly irregular closed shape. Same seed gives the same shape.
Path blobPath(Size size, int seed) {
  final rnd = Random(seed);
  const n = 8;
  final c = Offset(size.width / 2, size.height / 2);
  final pts = <Offset>[];
  for (var i = 0; i < n; i++) {
    final a = 2 * pi * i / n;
    final k = 0.82 + rnd.nextDouble() * 0.18;
    pts.add(
      Offset(
        c.dx + cos(a) * size.width / 2 * k,
        c.dy + sin(a) * size.height / 2 * k,
      ),
    );
  }
  final path = Path()..moveTo(pts[0].dx, pts[0].dy);
  for (var i = 0; i < n; i++) {
    final p0 = pts[(i - 1 + n) % n];
    final p1 = pts[i];
    final p2 = pts[(i + 1) % n];
    final p3 = pts[(i + 2) % n];
    final c1 = p1 + (p2 - p0) / 6;
    final c2 = p2 - (p3 - p1) / 6;
    path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
  }
  return path..close();
}

class BlobClipper extends CustomClipper<Path> {
  const BlobClipper(this.seed);

  final int seed;

  @override
  Path getClip(Size size) => blobPath(size, seed);

  @override
  bool shouldReclip(BlobClipper oldClipper) => oldClipper.seed != seed;
}

/// Coloured organic frame around an icon, a letter, or a picture.
class BlobFrame extends StatelessWidget {
  const BlobFrame({
    super.key,
    required this.size,
    required this.color,
    required this.child,
    this.seed = 1,
  });

  final double size;
  final Color color;
  final Widget child;
  final int seed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipPath(
        clipper: BlobClipper(seed),
        child: ColoredBox(
          color: color,
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Avatar that shows the first letter of a name inside a blob.
class BlobAvatar extends StatelessWidget {
  const BlobAvatar({
    super.key,
    required this.name,
    required this.color,
    this.size = 56,
    this.seed = 1,
  });

  final String name;
  final Color color;
  final double size;
  final int seed;

  @override
  Widget build(BuildContext context) {
    return BlobFrame(
      size: size,
      color: color,
      seed: seed,
      child: ExcludeSemantics(
        child: Text(
          name.characters.first,
          style: TextStyle(
            fontSize: size * 0.42,
            fontWeight: FontWeight.w700,
            color: AppColors.deep,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}
