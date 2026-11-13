import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/blob.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';
import 'post_problem_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenSearch});

  final void Function(Trade? trade) onOpenSearch;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final nearby = [...technicians]
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    final state = AppState.instance;

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) => ListView(
        padding: EdgeInsets.zero,
        children: [
          WaveHeader(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.handyman_rounded,
                          color: AppColors.deep,
                        ),
                        const SizedBox(width: 8),
                        Text('فنّي', style: text.titleLarge),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: AppColors.deep,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'عمّان',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text('شو بدك تصلّح اليوم؟', style: text.headlineMedium),
                    const SizedBox(height: 14),
                    Material(
                      color: AppColors.white,
                      shape: const StadiumBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => onOpenSearch(null),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: AppColors.muted,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'دوّر على فني أو صنعة',
                                style: TextStyle(color: AppColors.muted),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (state.isTech) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 14),
              child: SectionTitle('مشاكل بتدوّر على فني'),
            ),
            for (final p in state.problems.where((p) => p.open))
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: ProblemCard(post: p),
              ),
            const SizedBox(height: 10),
          ] else
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _PostProblemBanner(),
            ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 14),
            child: SectionTitle('الصنعات'),
          ),
          SignRail(
            children: [
              for (final t in Trade.values)
                SignChip(
                  label: t.label,
                  icon: t.icon,
                  onTap: () => onOpenSearch(t),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 22, 12, 12),
            child: SectionTitle(
              'فنيين قريبين منك',
              actionLabel: 'عرض الكل',
              onAction: () => onOpenSearch(null),
            ),
          ),
          SizedBox(
            height: 172,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: nearby.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => TechCard(tech: nearby[i]),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 14),
            child: SectionTitle('آخر الأعمال'),
          ),
          for (final post in posts)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PostCard(post: post),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Home call-to-action: post a problem with a photo instead of searching.
class _PostProblemBanner extends StatelessWidget {
  const _PostProblemBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.deep,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مش عارف مين يحل مشكلتك؟',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'انشرها مع صورة، والفنيين المهتمين بيردّوا عليك.',
                  style: TextStyle(
                    color: AppColors.surface,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.light,
                    foregroundColor: AppColors.deep,
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PostProblemScreen(),
                    ),
                  ),
                  child: const Text('انشر مشكلتك'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const BlobFrame(
            size: 70,
            color: AppColors.yellow,
            seed: 5,
            child: Icon(
              Icons.campaign_outlined,
              size: 34,
              color: AppColors.deep,
            ),
          ),
        ],
      ),
    );
  }
}
