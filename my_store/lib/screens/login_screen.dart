import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context
          .read<AuthProvider>()
          .login(_nameCtrl.text.trim(), _emailCtrl.text.trim());
    }
  }

  InputDecoration _decoration(String label, IconData icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: isDark ? Colors.grey[850] : Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    const primary = Color(0xFF6D3FC0);
    const beige = Color(0xFFF7F9FC);

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : beige,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primary, width: 2.5),
                      color: beige,
                    ),
                    child: const Icon(Icons.person, size: 50, color: primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration:
                        _decoration('الاسم', Icons.person_outline, isDark),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'الرجاء إدخال الاسم'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    decoration: _decoration(
                        'البريد الإلكتروني', Icons.email_outlined, isDark),
                    validator: (v) {
                      if (v == null || !v.contains('@') || !v.contains('.')) {
                        return 'الرجاء إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'دخول',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}