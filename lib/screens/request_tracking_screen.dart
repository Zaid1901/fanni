import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/blob.dart';
import '../widgets/common.dart';
import '../widgets/winding_steps.dart';
import 'requests_screen.dart';

class RequestTrackingScreen extends StatefulWidget {
  const RequestTrackingScreen({super.key, required this.request});

  final JobRequest request;

  @override
  State<RequestTrackingScreen> createState() => _RequestTrackingScreenState();
}

class _RequestTrackingScreenState extends State<RequestTrackingScreen> {
  static const _steps = [
    StepItem('انبعث الطلب', 'وصل طلبك للفني', AppColors.yellow),
    StepItem('وصلك سعر تقريبي', 'راجع السعر ووافق عليه', AppColors.orange),
    StepItem('تحدد الموعد', 'الفني جاي على الموعد', AppColors.lilac),
    StepItem('خلص الشغل', 'قيّم تجربتك مع الفني', AppColors.brand),
  ];
  static const _tags = ['الالتزام بالوقت', 'النظافة', 'السعر', 'جودة الشغل'];

  int _stars = 0;
  final _picked = <String>{};
  bool _starError = false;

  JobRequest get _r => widget.request;

  void _update(VoidCallback change) {
    setState(change);
    AppState.instance.touch();
  }

  void _sendRating() {
    if (_stars == 0) {
      setState(() => _starError = true);
      return;
    }
    _update(() {
      _r.myRating = _stars;
      _r.status = RequestStatus.rated;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('انحفظ تقييمك')));
  }

  @override
  Widget build(BuildContext context) {
    final hasQuote = _r.quoteFrom != null && _r.quoteTo != null;
    return Scaffold(
      appBar: AppBar(title: const Text('متابعة الطلب')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          AppCard(
            child: Row(
              children: [
                BlobAvatar(
                  name: _r.tech.name,
                  color: _r.tech.trade.color,
                  size: 52,
                  seed: _r.tech.id,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _r.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${_r.tech.name} · ${_r.area} · ${_r.when}',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusPill(status: _r.status),
              ],
            ),
          ),
          if (hasQuote) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.deep,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'السعر التقريبي',
                    style: TextStyle(color: AppColors.light, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    priceRange(_r.quoteFrom!, _r.quoteTo!),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'السعر النهائي بيتحدد بعد ما الفني يشوف المكان.',
                    style: TextStyle(color: AppColors.surface, fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          WindingSteps(
            steps: _steps,
            // After rating, every step counts as finished.
            activeIndex: _r.status == RequestStatus.rated
                ? _steps.length
                : min(_r.status.index, _steps.length - 1),
            rowHeight: 92,
          ),
          const SizedBox(height: 10),
          _actions(),
        ],
      ),
    );
  }

  Widget _actions() {
    switch (_r.status) {
      case RequestStatus.sent:
        return Column(
          children: [
            const Text(
              'بنستنى رد الفني. بيوصلك إشعار أول ما يبعت السعر.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 12),
            PillButton(
              label: 'محاكاة رد الفني (للعرض فقط)',
              outlined: true,
              onPressed: () => _update(() {
                _r.quoteFrom = 40;
                _r.quoteTo = 60;
                _r.status = RequestStatus.quoted;
              }),
            ),
          ],
        );
      case RequestStatus.quoted:
        return Column(
          children: [
            PillButton(
              label: 'موافق على السعر',
              icon: Icons.check_rounded,
              onPressed: () =>
                  _update(() => _r.status = RequestStatus.scheduled),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('بفكر فيها'),
            ),
          ],
        );
      case RequestStatus.scheduled:
        return PillButton(
          label: 'الفني خلّص الشغل',
          icon: Icons.task_alt_rounded,
          onPressed: () => _update(() => _r.status = RequestStatus.done),
        );
      case RequestStatus.done:
        return AppCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'كيف كان الشغل؟',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  for (var i = 1; i <= 5; i++)
                    IconButton(
                      tooltip: '$i من 5',
                      iconSize: 36,
                      padding: const EdgeInsets.all(4),
                      icon: Icon(
                        i <= _stars
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: i <= _stars ? AppColors.yellow : AppColors.muted,
                      ),
                      onPressed: () => setState(() {
                        _stars = i;
                        _starError = false;
                      }),
                    ),
                ],
              ),
              if (_starError)
                const Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Text(
                    'اختار عدد النجوم أول',
                    style: TextStyle(color: AppColors.danger, fontSize: 12.5),
                  ),
                ),
              const SizedBox(height: 6),
              const Text(
                'شو أكثر إشي عجبك؟',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in _tags)
                    FilterChip(
                      label: Text(tag),
                      selected: _picked.contains(tag),
                      showCheckmark: false,
                      selectedColor: AppColors.light,
                      backgroundColor: AppColors.surface,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                      onSelected: (on) => setState(
                        () => on ? _picked.add(tag) : _picked.remove(tag),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              PillButton(label: 'أرسل التقييم', onPressed: _sendRating),
            ],
          ),
        );
      case RequestStatus.rated:
        return AppCard(
          color: AppColors.surface,
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const Icon(Icons.verified_rounded, color: AppColors.brand),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'شكراً، قيّمت الشغل بـ ${_r.myRating ?? 5} من 5.',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
    }
  }
}
