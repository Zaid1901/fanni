import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../widgets/blob.dart';
import '../widgets/common.dart';
import 'login_screen.dart';
import 'my_works_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void _soon(BuildContext context, String what) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$what بيتفعّل لاحقاً.')));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = AppState.instance;
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            Row(
              children: [
                const BlobAvatar(
                  name: 'ضيف',
                  color: AppColors.yellow,
                  size: 64,
                  seed: 11,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('حسابي', style: text.titleLarge),
                      Text(
                        state.isTech
                            ? 'فني تجريبي · عمّان'
                            : 'زبون تجريبي · عمّان',
                        style: const TextStyle(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Material(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              clipBehavior: Clip.antiAlias,
              child: SwitchListTile(
                value: state.isTech,
                onChanged: state.setTechMode,
                title: const Text(
                  'وضع الفني',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text(
                  'شوف التطبيق زي ما بيشوفه الفني (للتجربة)',
                ),
              ),
            ),
            if (state.isTech) ...[
              const SizedBox(height: 10),
              _Row(
                icon: Icons.photo_library_outlined,
                label: 'أعمالي وتقييماتي',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MyWorksScreen()),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.deep,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'للفنيين',
                    style: TextStyle(
                      color: AppColors.light,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'فنّي المميّز',
                    style: text.headlineMedium?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final line in const [
                    'ظهور أعلى بنتائج البحث',
                    'شغلك بيوصل لمناطق أوسع',
                    'صور أكثر لأعمالك السابقة',
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.light,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              line,
                              style: const TextStyle(color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.light,
                        foregroundColor: AppColors.deep,
                      ),
                      onPressed: () => _soon(context, 'الاشتراك المميّز'),
                      child: const Text('جرّب المميّز'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _Row(
              icon: Icons.person_outline_rounded,
              label: 'معلوماتي',
              onTap: () => _soon(context, 'تعديل المعلومات'),
            ),
            _Row(
              icon: Icons.workspace_premium_outlined,
              label: 'شهادة المزاولة',
              onTap: () => _soon(context, 'رفع الشهادة'),
            ),
            _Row(
              icon: Icons.help_outline_rounded,
              label: 'المساعدة',
              onTap: () => _soon(context, 'مركز المساعدة'),
            ),
            _Row(
              icon: Icons.logout_rounded,
              label: 'تسجيل الخروج',
              onTap: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppColors.brand),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const ForwardChevron(),
          ],
        ),
      ),
    );
  }
}
