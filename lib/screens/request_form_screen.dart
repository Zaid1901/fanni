import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/blob.dart';
import '../widgets/common.dart';
import 'request_tracking_screen.dart';

class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({super.key, required this.tech});

  final Technician tech;

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  static const _times = ['اليوم', 'بكرا', 'هالأسبوع', 'مش مستعجل'];

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _details = TextEditingController();
  final _area = TextEditingController();
  String _when = _times.first;

  @override
  void dispose() {
    _title.dispose();
    _details.dispose();
    _area.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final request = JobRequest(
      tech: widget.tech,
      title: _title.text.trim(),
      details: _details.text.trim(),
      area: _area.text.trim(),
      when: _when,
    );
    AppState.instance.add(request);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RequestTrackingScreen(request: request),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('انبعث طلبك لـ ${widget.tech.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tech = widget.tech;
    return Scaffold(
      appBar: AppBar(title: const Text('طلب جديد')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  color: AppColors.surface,
                  child: Row(
                    children: [
                      BlobAvatar(
                        name: tech.name,
                        color: tech.trade.color,
                        size: 48,
                        seed: tech.id,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tech.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${tech.trade.label} · ${tech.city}',
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RatingInline(
                        rating: tech.rating,
                        count: tech.reviewsCount,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                LabeledField(
                  label: 'شو الشغل المطلوب؟',
                  child: TextFormField(
                    controller: _title,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: tech.works.first.title,
                    ),
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'اكتب شو الشغل المطلوب'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                LabeledField(
                  label: 'تفاصيل (اختياري)',
                  child: TextFormField(
                    controller: _details,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'القياسات، نوع المواد، أي ملاحظة بتساعد الفني',
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
                const Padding(
                  padding: EdgeInsetsDirectional.only(start: 4, bottom: 8),
                  child: Text(
                    'متى بدك الفني؟',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
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
                const SizedBox(height: 18),
                const Padding(
                  padding: EdgeInsetsDirectional.only(start: 4, bottom: 8),
                  child: Text(
                    'صور (اختياري)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                AppCard(
                  color: AppColors.background,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('رفع الصور بيتفعّل مع الـbackend.'),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: AppColors.brand,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'أضف صور للمكان، بتساعد الفني يعطيك سعر أدق',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                PillButton(
                  label: 'أرسل الطلب',
                  icon: Icons.send_rounded,
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
