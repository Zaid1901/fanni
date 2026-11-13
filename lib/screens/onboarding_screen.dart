import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/winding_steps.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const _steps = [
    StepItem('اطلب فني', 'اكتب شو بدك تصلّح وأضف صور', AppColors.yellow),
    StepItem(
      'استلم سعر تقريبي',
      'الفني بيرد عليك بسعر قبل ما ييجي',
      AppColors.orange,
    ),
    StepItem(
      'الفني بيوصل',
      'بتتفقوا على الموعد وبيبلّش الشغل',
      AppColors.lilac,
    ),
    StepItem('قيّم الشغل', 'تقييمك بيساعد غيرك يختار صح', AppColors.brand),
  ];

  void _goToLogin(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final still = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      body: Column(
        children: [
          WaveHeader(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
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
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text('كيف بيشتغل فنّي؟', style: text.headlineMedium),
                    const SizedBox(height: 4),
                    Text('أربع خطوات وبيوصلك الفني', style: text.bodyLarge),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: still ? 1 : 0, end: 1),
                duration: Duration(milliseconds: still ? 0 : 1800),
                curve: Curves.easeInOut,
                builder: (_, value, _) =>
                    WindingSteps(steps: _steps, progress: value),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: Column(
                children: [
                  PillButton(
                    label: 'يلا نبلّش',
                    onPressed: () => _goToLogin(context),
                  ),
                  TextButton(
                    onPressed: () => _goToLogin(context),
                    child: const Text('عندي حساب، سجّل دخولي'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
