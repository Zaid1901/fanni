import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../data/models.dart';
import '../theme/app_colors.dart';
import 'common.dart';
import 'work_art.dart';

/// Shows a picked photo, or the drawn placeholder when there is none.
class WorkImage extends StatelessWidget {
  const WorkImage({super.key, required this.trade, this.image, this.seed = 0});

  final Trade trade;
  final Uint8List? image;
  final int seed;

  @override
  Widget build(BuildContext context) {
    if (image == null) return WorkArt(trade: trade, seed: seed);
    return Image.memory(
      image!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      excludeFromSemantics: true,
    );
  }
}

/// Photo of a customer's problem. With no photo it says so plainly.
class ProblemImage extends StatelessWidget {
  const ProblemImage({super.key, required this.trade, this.image});

  final Trade trade;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Image.memory(
        image!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        excludeFromSemantics: true,
      );
    }
    return ColoredBox(
      color: AppColors.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(trade.icon, size: 40, color: AppColors.brand),
            const SizedBox(height: 6),
            const Text(
              'بدون صورة',
              style: TextStyle(color: AppColors.muted, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lets the user pick one photo from their device and shows a preview.
class PhotoPickerTile extends StatelessWidget {
  const PhotoPickerTile({
    super.key,
    required this.image,
    required this.onChanged,
    required this.hint,
  });

  final Uint8List? image;
  final ValueChanged<Uint8List?> onChanged;
  final String hint;

  Future<void> _pick(BuildContext context) async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 80,
      );
      if (file == null) return;
      onChanged(await file.readAsBytes());
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ما قدرنا نفتح الصور. جرّب مرة ثانية.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return AppCard(
        color: AppColors.background,
        onTap: () => _pick(context),
        child: Row(
          children: [
            const Icon(
              Icons.add_photo_alternate_outlined,
              color: AppColors.brand,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(hint, style: const TextStyle(color: AppColors.muted)),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.memory(
              image!,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => _pick(context),
              icon: const Icon(Icons.swap_horiz_rounded, size: 20),
              label: const Text('غيّر الصورة'),
            ),
            TextButton.icon(
              onPressed: () => onChanged(null),
              style: TextButton.styleFrom(foregroundColor: AppColors.danger),
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              label: const Text('احذف الصورة'),
            ),
          ],
        ),
      ],
    );
  }
}
