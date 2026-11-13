import 'package:material_ui/material_ui.dart';

import '../data/models.dart';
import '../screens/problem_detail_screen.dart';
import '../screens/request_form_screen.dart';
import '../screens/tech_profile_screen.dart';
import '../theme/app_colors.dart';
import 'blob.dart';
import 'common.dart';
import 'photo.dart';
import 'work_art.dart';

void openProfile(BuildContext context, Technician tech) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => TechProfileScreen(tech: tech)));
}

void openRequestForm(BuildContext context, Technician tech) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => RequestFormScreen(tech: tech)));
}

/// Small vertical card for the "near you" row.
class TechCard extends StatelessWidget {
  const TechCard({super.key, required this.tech});

  final Technician tech;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      child: AppCard(
        onTap: () => openProfile(context, tech),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlobAvatar(
              name: tech.name,
              color: tech.trade.color,
              size: 60,
              seed: tech.id,
            ),
            const SizedBox(height: 10),
            Text(
              tech.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            Text(
              '${tech.trade.label} · ${tech.district}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
            ),
            const SizedBox(height: 6),
            RatingInline(rating: tech.rating, count: tech.reviewsCount),
          ],
        ),
      ),
    );
  }
}

/// Full-width row for search results.
class TechTile extends StatelessWidget {
  const TechTile({super.key, required this.tech});

  final Technician tech;

  @override
  Widget build(BuildContext context) {
    final km = tech.distanceKm < 10
        ? tech.distanceKm.toStringAsFixed(1)
        : tech.distanceKm.toStringAsFixed(0);
    return AppCard(
      onTap: () => openProfile(context, tech),
      child: Row(
        children: [
          BlobAvatar(
            name: tech.name,
            color: tech.trade.color,
            size: 60,
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
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${tech.trade.label} · ${tech.city}، ${tech.district} · $km كم',
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
                    RatingInline(rating: tech.rating, count: tech.reviewsCount),
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
          const ForwardChevron(),
        ],
      ),
    );
  }
}

/// A technician's post in the home feed.
class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final tech = post.tech;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => openProfile(context, tech),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                children: [
                  BlobAvatar(
                    name: tech.name,
                    color: tech.trade.color,
                    size: 46,
                    seed: tech.id,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tech.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${tech.trade.label} · ${tech.city} · ${post.when}',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const ForwardChevron(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              post.text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: WorkArt(trade: tech.trade, seed: post.work.seed),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'السعر التقريبي',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                      Text(
                        priceRange(post.work.priceFrom, post.work.priceTo),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: () => openRequestForm(context, tech),
                  child: const Text('اطلب سعر'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A customer's problem post, as a row in a list.
class ProblemCard extends StatelessWidget {
  const ProblemCard({super.key, required this.post});

  final ProblemPost post;

  @override
  Widget build(BuildContext context) {
    final n = post.interested.length;
    final status = post.chosen != null
        ? 'اخترت ${post.chosen!.name}'
        : (n == 0 ? 'لسا ما في مهتمين' : '$n فني مهتم');
    return AppCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProblemDetailScreen(post: post)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 64,
              height: 64,
              child: post.image != null
                  ? ProblemImage(trade: post.trade, image: post.image)
                  : ColoredBox(
                      color: AppColors.surface,
                      child: Icon(
                        post.trade.icon,
                        color: AppColors.brand,
                        size: 28,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.5,
                  ),
                ),
                Text(
                  '${post.trade.label} · ${post.area} · ${post.when}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(
                    color: AppColors.brand,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const ForwardChevron(),
        ],
      ),
    );
  }
}
