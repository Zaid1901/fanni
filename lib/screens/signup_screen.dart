import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'home_shell.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isTech = false;
  Trade? _trade;
  bool _tradeError = false;
  bool _hidden = true;
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    final ok = _formKey.currentState!.validate();
    final tradeMissing = _isTech && _trade == null;
    setState(() => _tradeError = tradeMissing);
    if (!ok || tradeMissing) return;
    AppState.instance.register(
      Account(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        isTech: _isTech,
      ),
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('كيف بدك تستخدم فنّي؟', style: text.titleLarge),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _RoleCard(
                        icon: Icons.search_rounded,
                        title: 'بدوّر على فني',
                        subtitle: 'اطلب وقارن وقيّم',
                        color: AppColors.yellow,
                        selected: !_isTech,
                        onTap: () => setState(() => _isTech = false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RoleCard(
                        icon: Icons.handyman_rounded,
                        title: 'أنا فني',
                        subtitle: 'اعرض شغلك واستقبل طلبات',
                        color: AppColors.lilac,
                        selected: _isTech,
                        onTap: () => setState(() => _isTech = true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                LabeledField(
                  label: 'الاسم الكامل',
                  child: TextFormField(
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'اكتب اسمك الكامل'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                LabeledField(
                  label: 'البريد الإلكتروني',
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.end,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'name@example.com',
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                    ),
                    validator: (v) {
                      if (v == null || !v.contains('@')) {
                        return 'اكتب بريد إلكتروني صحيح';
                      }
                      if (AppState.instance.findAccount(v) != null) {
                        return 'هاد الإيميل مسجّل. سجّل دخولك.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                LabeledField(
                  label: 'كلمة المرور',
                  child: TextFormField(
                    controller: _password,
                    obscureText: _hidden,
                    decoration: InputDecoration(
                      hintText: '8 أحرف على الأقل',
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
                    validator: (v) => (v == null || v.length < 8)
                        ? 'كلمة المرور لازم تكون 8 أحرف على الأقل'
                        : null,
                  ),
                ),
                if (_isTech) ...[
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 4, bottom: 8),
                    child: Text(
                      'شو صنعتك؟',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in Trade.values)
                        ChoiceChip(
                          label: Text(t.label),
                          avatar: Icon(t.icon, size: 18),
                          selected: _trade == t,
                          showCheckmark: false,
                          selectedColor: AppColors.light,
                          backgroundColor: AppColors.surface,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                          onSelected: (_) => setState(() {
                            _trade = t;
                            _tradeError = false;
                          }),
                        ),
                    ],
                  ),
                  if (_tradeError)
                    const Padding(
                      padding: EdgeInsetsDirectional.only(start: 4, top: 6),
                      child: Text(
                        'اختار صنعتك',
                        style: TextStyle(
                          color: AppColors.danger,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 26),
                PillButton(label: 'إنشاء الحساب', onPressed: _submit),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لديك حساب بالفعل؟'),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('تسجيل الدخول'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.surface : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: selected ? AppColors.deep : AppColors.line,
          width: selected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Semantics(
          button: true,
          selected: selected,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: AppColors.deep, size: 22),
                    ),
                    const Spacer(),
                    Icon(
                      selected
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: selected ? AppColors.deep : AppColors.line,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
