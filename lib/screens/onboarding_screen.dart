import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_routes.dart';
import '../shared/custom_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _current = 0;

  final List<_OnboardData> _pages = const [
    _OnboardData(
      title: 'UMKM: Tulang Punggung Ekonomi',
      body:
          'UMKM berkontribusi hingga 61% terhadap PDB dan menyerap ~97% tenaga kerja. Namun banyak pelaku usaha, khususnya sektor kreatif, kesulitan mengakses pendanaan formal karena minimnya agunan fisik.',
      icon: Icons.store_mall_directory,
    ),
    _OnboardData(
      title: 'Aset Digital Bernilai, Sulit Diverifikasi',
      body:
          'Karya digital, interaksi media sosial, hingga portofolio pelanggan adalah aset non-fisik bernilai tinggi—namun belum mudah diverifikasi lembaga keuangan, menciptakan kesenjangan kepercayaan.',
      icon: Icons.verified_user,
    ),
    _OnboardData(
      title: 'Solusi: Penilaian Holistik',
      body:
          'Aplikasi ini menjembatani UMKM dan pemberi dana melalui sistem penilaian holistik atas metrik digital. Bantu pemilik usaha membuktikan kredibilitas dan menampilkan potensi pertumbuhan secara akurat.',
      icon: Icons.insights,
    ),
    _OnboardData(
      title: 'Mulai Bangun Kredibilitas',
      body:
          'Daftar atau masuk untuk memanfaatkan penilaian holistik dan tampilkan potensi pertumbuhan bisnismu.',
      icon: Icons.app_registration,
    ),
  ];

  Future<void> _complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  Future<void> _markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }

  void _next() {
    if (_current < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _complete();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, index) {
                final iconColor = theme.colorScheme.onPrimaryContainer;
                return Center(
                  child: Icon(_pages[index].icon, size: 160, color: iconColor),
                );
              },
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 6),
                        height: 4,
                        width: _current == i ? 24 : 12,
                        decoration: BoxDecoration(
                          color: _current == i
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _pages[_current].title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    _pages[_current].body,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      height: 1.4,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_current == _pages.length - 1)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.onSurface,
                              side: BorderSide(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              await _markSeen();
                              if (!mounted) return;
                              this.context.go(AppRoutes.login);
                            },
                            child: const Text('Masuk'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              await _markSeen();
                              if (!mounted) return;
                              this.context.go(AppRoutes.register);
                            },
                            child: const Text('Daftar'),
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _next,
                        child: const Text('Lanjut'),
                      ),
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

class _OnboardData {
  final String title;
  final String body;
  final IconData icon;
  const _OnboardData({
    required this.title,
    required this.body,
    required this.icon,
  });
}
