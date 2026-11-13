import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/blob.dart';
import '../widgets/common.dart';
import '../widgets/photo.dart';
import 'tech_profile_screen.dart';

/// The technician's own page: their work photos and what customers said.
class MyWorksScreen extends StatelessWidget {
  const MyWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('أعمالي وتقييماتي')),
      body: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) {
          final works = AppState.instance.myWorks;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              Row(
                children: [
                  BlobAvatar(
                    name: myTech.name,
                    color: myTech.trade.color,
                    size: 72,
                    seed: myTech.id,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(myTech.name, style: text.titleLarge),
                        Text(
                          '${myTech.trade.label} · ${myTech.city}، ${myTech.district}',
                          style: const TextStyle(color: AppColors.muted),
                        ),
                        const SizedBox(height: 6),
                        RatingInline(
                          rating: myTech.rating,
                          count: myTech.reviewsCount,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SectionTitle('أعمالي (${works.length})'),
              const SizedBox(height: 12),
              PillButton(
                label: 'أضف عمل جديد',
                icon: Icons.add_a_photo_outlined,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddWorkScreen()),
                ),
              ),
              const SizedBox(height: 14),
              if (works.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'اعرض أول شغل إلك. الصور أكثر إشي بيقنع الزبون.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              for (final w in works)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: WorkImage(
                            trade: myTech.trade,
                            image: w.image,
                            seed: w.seed,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  w.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Text(
                                priceRange(w.priceFrom, w.priceTo),
                                style: const TextStyle(
                                  color: AppColors.brand,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 14),
              SectionTitle('تقييمات الزباين (${myTech.reviews.length})'),
              const SizedBox(height: 12),
              for (final r in myTech.reviews)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ReviewTile(review: r),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Form for adding one finished job, with a photo and a price range.
class AddWorkScreen extends StatefulWidget {
  const AddWorkScreen({super.key});

  @override
  State<AddWorkScreen> createState() => _AddWorkScreenState();
}

class _AddWorkScreenState extends State<AddWorkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _from = TextEditingController();
  final _to = TextEditingController();
  Uint8List? _image;

  @override
  void dispose() {
    _title.dispose();
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    AppState.instance.addMyWork(
      Work(
        _title.text.trim(),
        int.parse(_from.text),
        int.parse(_to.text),
        AppState.instance.myWorks.length + 40,
        image: _image,
      ),
    );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('انضاف العمل لملفك')));
  }

  String? _price(String? v) =>
      (v == null || int.tryParse(v) == null) ? 'اكتب رقم' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عمل جديد')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.only(start: 4, bottom: 8),
                  child: Text(
                    'صورة الشغل',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                PhotoPickerTile(
                  image: _image,
                  hint: 'أضف صورة للشغل بعد ما خلص',
                  onChanged: (bytes) => setState(() => _image = bytes),
                ),
                const SizedBox(height: 16),
                LabeledField(
                  label: 'شو الشغل؟',
                  child: TextFormField(
                    controller: _title,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'تمديد كهرباء مطبخ',
                    ),
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'اكتب اسم الشغل'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsetsDirectional.only(start: 4, bottom: 6),
                  child: Text(
                    'السعر التقريبي (دينار)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _from,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(hintText: 'من'),
                        validator: _price,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _to,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(hintText: 'لـ'),
                        validator: (v) {
                          final to = int.tryParse(v ?? '');
                          if (to == null) return 'اكتب رقم';
                          final from = int.tryParse(_from.text);
                          if (from != null && to < from) {
                            return 'لازم يكون أكبر من "من"';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                PillButton(label: 'أضف لملفي', onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
