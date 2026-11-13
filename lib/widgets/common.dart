import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

/// Full-width pill button. Filled by default, outlined when [outlined].
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final Widget child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(label),
            ],
          );
    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(onPressed: onPressed, child: child)
          : FilledButton(onPressed: onPressed, child: child),
    );
  }
}

/// Curved-bottom coloured header used at the top of main screens.
class WaveHeader extends StatelessWidget {
  const WaveHeader({
    super.key,
    required this.child,
    this.color = AppColors.light,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const _WaveClipper(),
      child: Container(
        width: double.infinity,
        color: color,
        padding: const EdgeInsets.only(bottom: 48),
        child: child,
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  const _WaveClipper();

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..lineTo(0, h - 16)
      ..cubicTo(w * 0.30, h + 4, w * 0.62, h - 62, w, h - 24)
      ..lineTo(w, 0)
      ..close();
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) => false;
}

/// Section heading with a short hand-drawn style underline.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class StatNumber extends StatelessWidget {
  const StatNumber({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.deep,
            height: 1.2,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
        ),
      ],
    );
  }
}

class RatingInline extends StatelessWidget {
  const RatingInline({super.key, required this.rating, required this.count});

  final double rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'التقييم $rating من 5، $count تقييم',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 18, color: AppColors.yellow),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

/// Practice-licence badge. Shows the level, and whether the photo was reviewed.
class CertBadge extends StatelessWidget {
  const CertBadge({
    super.key,
    required this.level,
    required this.reviewed,
    this.compact = false,
  });

  final int level;
  final bool reviewed;
  final bool compact;

  static String levelName(int level) => switch (level) {
    2 => 'محدد المهارة',
    3 => 'ماهر',
    _ => 'مهني',
  };

  @override
  Widget build(BuildContext context) {
    final name = levelName(level);
    final label = compact ? name : 'شهادة مزاولة · $name';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.brand, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            reviewed
                ? Icons.workspace_premium_rounded
                : Icons.hourglass_top_rounded,
            size: 16,
            color: AppColors.brand,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              reviewed ? label : '$label · قيد المراجعة',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.deep,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A form field with its label above it.
class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        child,
      ],
    );
  }
}

/// White rounded card that can be tapped.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(14),
    this.color = AppColors.white,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Category chip drawn as a small sign hanging from a rail.
class SignChip extends StatelessWidget {
  const SignChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Widget rope() => Container(width: 2.5, height: 12, color: AppColors.deep);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [rope(), const SizedBox(width: 36), rope()],
        ),
        Material(
          color: selected ? AppColors.deep : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.deep, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Semantics(
              button: true,
              selected: selected,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: selected ? AppColors.light : AppColors.deep,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.3,
                        color: selected ? AppColors.white : AppColors.deep,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Horizontal row of [SignChip]s hanging from one rail line.
class SignRail extends StatelessWidget {
  const SignRail({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 12,
            right: 12,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.only(
              start: 20,
              end: 20,
              top: 3,
            ),
            itemCount: children.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) => children[i],
          ),
        ],
      ),
    );
  }
}

/// "Go forward" arrow at the end of a tappable row. Points left in Arabic.
class ForwardChevron extends StatelessWidget {
  const ForwardChevron({super.key});

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Icon(
      rtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
      // Fixed direction so the icon is never mirrored a second time.
      textDirection: TextDirection.ltr,
      color: AppColors.muted,
    );
  }
}
