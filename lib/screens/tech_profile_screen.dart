import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/blob.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';
import '../widgets/photo.dart';

class TechProfileScreen extends StatelessWidget {
  const TechProfileScreen({super.key, required this.tech});

  final Technician tech;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    // The signed-in technician's works live in the app state.
    final works = tech.id == myTech.id ? AppState.instance.myWorks : tech.works;

    return Scaffold(
      appBar: AppBar(title: const Text('ملف الفني')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Row(
            children: [
              BlobAvatar(
                name: tech.name,
                color: tech.trade.color,
                size: 88,
                seed: tech.id,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tech.name,
                      style: text.titleLarge?.copyWith(fontSize: 24),
                    ),
                    Text(
                      '${tech.trade.label} · ${tech.city}، ${tech.district}',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 8),
                    if (tech.certLevel != null)
                      CertBadge(
                        level: tech.certLevel!,
                        reviewed: tech.certReviewed,
                      )
                    else
                      const Text(
                        'لم يرفع شهادة مزاولة بعد',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12.5,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatNumber(
                  value: tech.rating.toStringAsFixed(1),
                  label: 'التقييم',
                ),
                StatNumber(value: '${tech.reviewsCount}', label: 'تقييم'),
                StatNumber(value: '${tech.years}', label: 'سنين خبرة'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionTitle('نبذة'),
          const SizedBox(height: 10),
          Text(tech.bio, style: text.bodyLarge),
          const SizedBox(height: 22),
          const SectionTitle('أعمال سابقة'),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: works.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) =>
                  _WorkCard(work: works[i], trade: tech.trade),
            ),
          ),
          const SizedBox(height: 22),
          const SectionTitle('التقييمات'),
          const SizedBox(height: 12),
          for (final r in tech.reviews)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ReviewTile(review: r),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: PillButton(
                  label: 'اطلب سعر تقريبي',
                  onPressed: () => openRequestForm(context, tech),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.outlined(
                tooltip: 'اتصال',
                style: IconButton.styleFrom(
                  minimumSize: const Size(52, 52),
                  side: const BorderSide(color: AppColors.deep, width: 1.6),
                  foregroundColor: AppColors.deep,
                ),
                icon: const Icon(Icons.call_outlined),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('الاتصال بيتفعّل لما نربط أرقام الفنيين.'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkCard extends StatelessWidget {
  const _WorkCard({required this.work, required this.trade});

  final Work work;
  final Trade trade;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 126,
              width: double.infinity,
              child: WorkImage(
                trade: trade,
                image: work.image,
                seed: work.seed,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    work.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    priceRange(work.priceFrom, work.priceTo),
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
    );
  }
}

class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.author,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Semantics(
                label: '${review.rating} من 5',
                excludeSemantics: true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 1; i <= 5; i++)
                      Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: i <= review.rating
                            ? AppColors.yellow
                            : AppColors.line,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(review.text),
          const SizedBox(height: 4),
          Text(
            review.when,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
