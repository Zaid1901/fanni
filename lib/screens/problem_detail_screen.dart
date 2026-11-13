import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/blob.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';
import '../widgets/photo.dart';
import 'post_problem_screen.dart';
import 'request_tracking_screen.dart';

/// One problem post. The customer sees interested technicians and picks one.
/// A technician sees an "I'm interested" button and never enters a price.
class ProblemDetailScreen extends StatelessWidget {
  const ProblemDetailScreen({super.key, required this.post});

  final ProblemPost post;

  void _choose(BuildContext context, Technician tech) {
    final request = JobRequest(
      tech: tech,
      title: post.title,
      details: post.details,
      area: post.area,
      when: post.when,
    );
    post.chosen = tech;
    post.request = request;
    AppState.instance.add(request);
    _openRequest(context, request);
  }

  void _openRequest(BuildContext context, JobRequest request) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RequestTrackingScreen(request: request),
      ),
    );
  }

  /// Demo only: pretend technicians of this trade tapped "interested".
  void _simulateInterest() {
    final matching = technicians.where((t) => t.trade == post.trade);
    final pool = matching.isNotEmpty ? matching : technicians.take(2);
    for (final t in pool) {
      if (!post.interested.contains(t)) post.interested.add(t);
    }
    AppState.instance.touch();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المشكلة')),
      body: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) {
          final asTech = AppState.instance.isTech;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: ProblemImage(trade: post.trade, image: post.image),
                ),
              ),
              const SizedBox(height: 16),
              Text(post.title, style: text.titleLarge?.copyWith(fontSize: 22)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Tag(icon: post.trade.icon, label: post.trade.label),
                  _Tag(icon: Icons.location_on_outlined, label: post.area),
                  _Tag(icon: Icons.schedule_rounded, label: post.when),
                  if (!post.mine)
                    _Tag(
                      icon: Icons.person_outline_rounded,
                      label: post.author,
                    ),
                ],
              ),
              if (post.details.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(post.details, style: text.bodyLarge),
              ],
              const SizedBox(height: 22),
              if (asTech)
                _techSide(context)
              else if (post.mine)
                ..._customerSide(context)
              else
                const NoAuctionNote(
                  text: 'هاي مشكلة نشرها زبون ثاني. بدّل لوضع الفني من "حسابي" إذا بدك تهتم فيها.',
                ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _customerSide(BuildContext context) {
    if (post.chosen != null) {
      return [
        AppCard(
          color: AppColors.surface,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.brand,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'اخترت ${post.chosen!.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text('بيبعتلك سعر تقريبي، وبتتابعوا من صفحة الطلب.'),
              const SizedBox(height: 12),
              PillButton(
                label: 'افتح الطلب',
                onPressed: () => _openRequest(context, post.request!),
              ),
            ],
          ),
        ),
      ];
    }
    return [
      SectionTitle('فنيين مهتمين (${post.interested.length})'),
      const SizedBox(height: 10),
      const Text(
        'مرتّبين حسب التقييم. السعر بتتفق عليه مع الفني اللي بتختاره.',
        style: TextStyle(color: AppColors.muted, fontSize: 13),
      ),
      const SizedBox(height: 12),
      if (post.interested.isEmpty) ...[
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'لسا ما في فنيين مهتمين. بيوصلك إشعار أول ما حدا يهتم.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
        ),
        PillButton(
          label: 'محاكاة اهتمام فنيين (للعرض فقط)',
          outlined: true,
          onPressed: _simulateInterest,
        ),
      ],
      for (final tech in [
        ...post.interested,
      ]..sort((a, b) => b.rating.compareTo(a.rating)))
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _InterestedCard(
            tech: tech,
            onChoose: () => _choose(context, tech),
          ),
        ),
    ];
  }

  Widget _techSide(BuildContext context) {
    if (post.chosen != null) {
      return const NoAuctionNote(text: 'الزبون اختار فني لهاي المشكلة.');
    }
    if (post.interested.contains(myTech)) {
      return const NoAuctionNote(
        text: 'سجّلنا اهتمامك. الزبون بيشوف ملفك وتقييماتك، وإذا اختارك بتتفقوا على السعر.',
      );
    }
    return Column(
      children: [
        PillButton(
          label: 'أنا مهتم',
          icon: Icons.front_hand_outlined,
          onPressed: () {
            post.interested.add(myTech);
            AppState.instance.touch();
          },
        ),
        const SizedBox(height: 8),
        const Text(
          'ما بتحط سعر هون. الزبون بيختار حسب ملفك وتقييماتك.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.brand),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestedCard extends StatelessWidget {
  const _InterestedCard({required this.tech, required this.onChoose});

  final Technician tech;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              BlobAvatar(
                name: tech.name,
                color: tech.trade.color,
                size: 54,
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
                        fontSize: 15.5,
                      ),
                    ),
                    Text(
                      '${tech.trade.label} · ${tech.district} · ${tech.years} سنين خبرة',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        RatingInline(
                          rating: tech.rating,
                          count: tech.reviewsCount,
                        ),
                        if (tech.certLevel != null)
                          CertBadge(
                            level: tech.certLevel!,
                            reviewed: tech.certReviewed,
                            compact: true,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                  ),
                  onPressed: () => openProfile(context, tech),
                  child: const Text('شوف شغله'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                  onPressed: onChoose,
                  child: const Text('اختار'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
