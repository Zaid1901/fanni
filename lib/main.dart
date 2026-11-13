import 'package:material_ui/material_ui.dart';

import 'screens/onboarding_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FanniApp());
}

class FanniApp extends StatelessWidget {
  const FanniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'فنّي',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      // Arabic locale makes every screen lay out right-to-left on its own.
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // On wide screens (web, tablets) keep the app at phone width.
      builder: (context, child) => ColoredBox(
        color: AppColors.surface,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ClipRect(child: child),
          ),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}
