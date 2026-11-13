import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../widgets/blob.dart';
import '../widgets/common.dart';
import 'home_shell.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidden = true;
  String? _authError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// One-tap demo accounts, so testers don't have to type anything.
  void _enterDemo({required bool asTech}) {
    AppState.instance.signIn(asTech ? demoTech : demoCustomer);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (_) => false,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // No backend yet: accounts are checked against the in-memory list.
    final account = AppState.instance.findAccount(_email.text);
    if (account == null || account.password != _password.text) {
      setState(
        () =>
            _authError = 'الإيميل أو كلمة المرور غلط. جرّب حساب تجريبي من تحت.',
      );
      return;
    }
    AppState.instance.signIn(account);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            WaveHeader(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                  child: Column(
                    children: [
                      const BlobFrame(
                        size: 88,
                        color: AppColors.white,
                        seed: 7,
                        child: Icon(
                          Icons.handyman_rounded,
                          size: 42,
                          color: AppColors.brand,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'مرحباً بك في فنّي',
                        style: text.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'استكشف الفنيين والحرفيين الأنسب لحاجتك',
                        style: text.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    LabeledField(
                      label: 'البريد الإلكتروني',
                      child: TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(
                          hintText: 'name@example.com',
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                        validator: (v) => (v == null || !v.contains('@'))
                            ? 'اكتب بريد إلكتروني صحيح'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LabeledField(
                      label: 'كلمة المرور',
                      child: TextFormField(
                        controller: _password,
                        obscureText: _hidden,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            tooltip: _hidden
                                ? 'إظهار كلمة المرور'
                                : 'إخفاء كلمة المرور',
                            icon: Icon(
                              _hidden
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(() => _hidden = !_hidden),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'اكتب كلمة المرور'
                            : null,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                    ),
                    if (_authError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _authError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    PillButton(label: 'تسجيل الدخول', onPressed: _submit),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'أو ادخل بحساب تجريبي',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _DemoButton(
                            icon: Icons.person_outline_rounded,
                            label: 'دخول كزبون',
                            onPressed: () => _enterDemo(asTech: false),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DemoButton(
                            icon: Icons.handyman_outlined,
                            label: 'دخول كفني',
                            onPressed: () => _enterDemo(asTech: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('ليس لديك حساب؟'),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          ),
                          child: const Text('سجّل الآن'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: text.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 6),
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
