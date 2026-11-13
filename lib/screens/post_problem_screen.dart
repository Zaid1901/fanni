import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/photo.dart';
import 'problem_detail_screen.dart';

/// The customer describes a problem, adds a photo, and posts it publicly.
class PostProblemScreen extends StatefulWidget {
  const PostProblemScreen({super.key});

  @override
  State<PostProblemScreen> createState() => _PostProblemScreenState();
}

class _PostProblemScreenState extends State<PostProblemScreen> {
  static const _times = ['اليوم', 'بكرا', 'هالأسبوع', 'مش مستعجل'];

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _details = TextEditingController();
  final _area = TextEditingController();
  Uint8List? _image;
  Trade? _trade;
  bool _tradeError = false;
  String _when = _times.first;

  @override
  void dispose() {
    _title.dispose();
    _details.dispose();
    _area.dispose();
    super.dispose();
  }

  void _submit() {
    final ok = _formKey.currentState!.validate();
    setState(() => _tradeError = _trade == null);
    if (!ok || _trade == null) return;
    final post = ProblemPost(
      title: _title.text.trim(),
      details: _details.text.trim(),
      area: _area.text.trim(),
      trade: _trade!,
      when: _when,
      image: _image,
    );
    AppState.instance.addProblem(post);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ProblemDetailScreen(post: post)),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('انتشرت مشكلتك')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('انشر مشكلتك')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NoAuctionNote(
                  text: 'الفنيين المهتمين بيردّوا عليك، وإنت بتختار حسب تقييمهم وشغلهم السابق. ما في مزاد على السعر.',
                ),
                const SizedBox(height: 20),
                LabeledField(
                  label: 'شو المشكلة؟',
                  child: TextFormField(
                    controller: _title,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'تسريب مي تحت المغسلة',
                    ),
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'اكتب شو المشكلة'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                const _Label('صورة للمشكلة (اختياري)'),
                PhotoPickerTile(
                  image: _image,
                  hint: 'أضف صورة، بتساعد الفني يفهم المشكلة أسرع',
                  onChanged: (bytes) => setState(() => _image = bytes),
                ),
                const SizedBox(height: 18),
                const _Label('أي صنعة بتحتاج؟'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in Trade.values)
                      ChoiceChip(
                        label: Text(t.label),
                        avatar: Icon(t.icon, size: 18),
                        selected: _trade == t,
                        showCheckmark: false,
                        selectedColor: AppColors.light,
                        backgroundColor: AppColors.surface,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                        onSelected: (_) => setState(() {
                          _trade = t;
                          _tradeError = false;
                        }),
                      ),
                  ],
                ),
                if (_tradeError)
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 4, top: 6),
                    child: Text(
                      'اختار الصنعة',
                      style: TextStyle(color: AppColors.danger, fontSize: 12.5),
                    ),
                  ),
                const SizedBox(height: 16),
                LabeledField(
                  label: 'تفاصيل (اختياري)',
                  child: TextFormField(
                    controller: _details,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'من متى المشكلة؟ شو جرّبت؟',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                LabeledField(
                  label: 'المنطقة',
                  child: TextFormField(
                    controller: _area,
                    decoration: const InputDecoration(
                      hintText: 'طبربور، عمّان',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'اكتب منطقتك' : null,
                  ),
                ),
                const SizedBox(height: 18),
                const _Label('متى بدك الفني؟'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in _times)
                      ChoiceChip(
                        label: Text(t),
                        selected: _when == t,
                        showCheckmark: false,
                        selectedColor: AppColors.light,
                        backgroundColor: AppColors.surface,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                        onSelected: (_) => setState(() => _when = t),
                      ),
                  ],
                ),
                const SizedBox(height: 26),
                PillButton(
                  label: 'انشر المشكلة',
                  icon: Icons.campaign_outlined,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}

/// Short reassurance that problem posts are not a price auction.
class NoAuctionNote extends StatelessWidget {
  const NoAuctionNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.handshake_outlined, color: AppColors.brand),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13.5, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
