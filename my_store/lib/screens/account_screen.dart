// lib/screens/account_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    const primary = Color(0xFF6D3FC0);
    const beige = Color(0xFFF4F2FA);

    if (!auth.loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!auth.isLoggedIn) {
      return const LoginScreen();
    }

    return Scaffold(
      backgroundColor: theme.isDark ? Colors.grey[900] : beige,
      appBar: AppBar(
        backgroundColor: theme.isDark ? Colors.grey[850] : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'حسابي',
          style: TextStyle(
            color: theme.isDark ? Colors.white : primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined,
                color: theme.isDark ? Colors.white : primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('الإعدادات'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Header ──────────────────────────────
            Container(
              width: double.infinity,
              color: theme.isDark ? Colors.grey[850] : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32),
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
                  const SizedBox(height: 14),
                  Text(
                    auth.name ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.isDark ? Colors.white : primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    auth.email ?? '',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Menu Items ──────────────────────────────────
            Container(
              color: theme.isDark ? Colors.grey[850] : Colors.white,
              child: Column(
                children: [
                  _AnimatedMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'طلباتي',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('لا توجد طلبات حتى الآن'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  _AnimatedMenuItem(
                    icon: Icons.location_on_outlined,
                    label: 'العناوين',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('لا توجد عناوين محفوظة'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  _AnimatedMenuItem(
                    icon: Icons.favorite_outline,
                    label: 'المفضلة',
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, a, b) => const FavoritesScreen(),
                          transitionsBuilder: (_, anim, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeInOut,
                              )),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  _AnimatedMenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'الإشعارات',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('لا توجد إشعارات جديدة'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Dark Mode Toggle ────────────────────────────
            Container(
              color: theme.isDark ? Colors.grey[850] : Colors.white,
              child: ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.dark_mode_outlined,
                      color: primary, size: 20),
                ),
                title: Text(
                  'الوضع الليلي',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.isDark ? Colors.white : Colors.black87,
                  ),
                ),
                trailing: Switch(
                  value: theme.isDark,
                  onChanged: (_) => theme.toggleTheme(),
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return Colors.grey;
                  }),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return primary;
                    }
                    return Colors.grey[300];
                  }),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Logout ──────────────────────────────────────
            Container(
              color: theme.isDark ? Colors.grey[850] : Colors.white,
              child: _AnimatedMenuItem(
                icon: Icons.logout,
                label: 'تسجيل الخروج',
                iconColor: Colors.red,
                labelColor: Colors.red,
                showArrow: false,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text(
                        'تسجيل الخروج',
                        textAlign: TextAlign.right,
                      ),
                      content: const Text(
                        'هل تريدين تسجيل الخروج؟',
                        textAlign: TextAlign.right,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Provider.of<AuthProvider>(context, listen: false)
                                .logout();
                          },
                          child: const Text(
                            'خروج',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Animated Menu Item ──────────────────────────────────────────────────────────
class _AnimatedMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final Color? labelColor;
  final bool showArrow;

  const _AnimatedMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor = const Color(0xFF6D3FC0),
    this.labelColor,
    this.showArrow = true,
  });

  @override
  State<_AnimatedMenuItem> createState() => _AnimatedMenuItemState();
}

class _AnimatedMenuItemState extends State<_AnimatedMenuItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.94),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.94, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _ctrl.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return ScaleTransition(
      scale: _scale,
      child: InkWell(
        onTap: _handleTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: widget.labelColor ??
                        (theme.isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ),
              if (widget.showArrow)
                Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}