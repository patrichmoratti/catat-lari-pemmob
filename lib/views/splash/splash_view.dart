import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/splash/splash_viewmodel.dart';
import '../auth/login_view.dart';
import '../dashboard/dashboard_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashViewModel(
        AuthService(),
      )..init(),
      child: const _SplashViewBody(),
    );
  }
}

class _SplashViewBody extends StatefulWidget {
  const _SplashViewBody();

  @override
  State<_SplashViewBody> createState() =>
      _SplashViewBodyState();
}

class _SplashViewBodyState
    extends State<_SplashViewBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  late final Animation<double> fade;

  late final Animation<double> scale;

  late final Animation<double> slide;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ),
    );

    fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0,
          0.6,
          curve: Curves.easeOut,
        ),
      ),
    );

    scale = Tween<double>(
      begin: 0.75,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0,
          0.6,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    slide = Tween<double>(
      begin: 20,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.3,
          0.8,
          curve: Curves.easeOut,
        ),
      ),
    );

    controller.forward();

    _navigate();
  }

  Future<void> _navigate() async {
    final vm =
        context.read<SplashViewModel>();

    await vm.init();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a1, a2) {
          return vm.isLoggedIn
              ? const DashboardView()
              : const LoginView();
        },
        transitionDuration:
            const Duration(milliseconds: 500),
        transitionsBuilder:
            (_, anim, a2, child) {
          return FadeTransition(
            opacity: anim,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary
                    .withValues(alpha: 0.06),
              ),
            ),
          ),

          Positioned(
            bottom: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary
                    .withValues(alpha: 0.04),
              ),
            ),
          ),

          Center(
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, child) {
                return FadeTransition(
                  opacity: fade,
                  child: ScaleTransition(
                    scale: scale,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient:
                          const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary
                              .withValues(
                            alpha: 0.35,
                          ),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.directions_run_rounded,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),

                  const SizedBox(height: 28),

                  AnimatedBuilder(
                    animation: slide,
                    builder: (_, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          slide.value,
                        ),
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback:
                              (bounds) {
                            return const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors
                                    .primaryLight,
                              ],
                            ).createShader(
                              bounds,
                            );
                          },
                          child: const Text(
                            'CATAT LARI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight:
                                  FontWeight.w800,
                              letterSpacing: 3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Lacak setiap langkah, rayakan setiap capaian.',
                          style: TextStyle(
                            color:
                                AppColors.textSecondary,
                            fontSize: 13,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),

                  SizedBox(
                    width: 28,
                    height: 28,
                    child:
                        CircularProgressIndicator(
                      valueColor:
                          const AlwaysStoppedAnimation<
                              Color>(
                        AppColors.primary,
                      ),
                      backgroundColor:
                          AppColors.primary
                              .withValues(
                        alpha: 0.15,
                      ),
                      strokeWidth: 2.5,
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