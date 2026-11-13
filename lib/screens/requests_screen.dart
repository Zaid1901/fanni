import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/blob.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';
import 'post_problem_screen.dart';
import 'request_tracking_screen.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) {
          final requests = AppState.instance.requests;
          final mine = AppState.instance.problems.where((p) => p.mine).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              SectionTitle(
                'مشاكلي المنشورة',
                actionLabel: 'انشر مشكلة',
                onAction: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PostProblemScreen()),
                ),
              ),
              const SizedBox(height: 14),
              if (mine.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'انشر مشكلتك مع صورة، والفنيين المهتمين بيردّوا عليك.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              for (final p in mine)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProblemCard(post: p),
                ),
              const SizedBox(height: 14),
              const SectionTitle('طلباتي'),
              const SizedBox(height: 16),
              if (requests.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 48,
                        color: AppColors.muted,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'اطلب أول فني',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'طلباتك وحالتها بتظهر هون.',
                        style: TextStyle(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              for (final r in requests)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RequestCard(request: r),
                ),
            ],
          );
        },
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      RequestStatus.sent => AppColors.surface,
      RequestStatus.quoted => AppColors.yellow,
      RequestStatus.scheduled => AppColors.lilac,
      RequestStatus.done => AppColors.orange,
      RequestStatus.rated => AppColors.light,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: AppColors.deep,
          height: 1.4,
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});

  final JobRequest request;

  @override
  Widget build(BuildContext context) {
    final hint = switch (request.status) {
      RequestStatus.quoted => 'بانتظار موافقتك على السعر',
      RequestStatus.done => 'قيّم الشغل',
      _ => null,
    };
    return AppCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RequestTrackingScreen(request: request),
        ),
      ),
      child: Row(
        children: [
          BlobAvatar(
            name: request.tech.name,
            color: request.tech.trade.color,
            size: 52,
            seed: request.tech.id,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.5,
                  ),
                ),
                Text(
                  '${request.tech.name} · ${request.when}',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StatusPill(status: request.status),
                    if (hint != null)
                      Text(
                        hint,
                        style: const TextStyle(
                          color: AppColors.brand,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
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
