import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/auth/login_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../dashboard/dashboard_view.dart';
import 'register_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(
        AuthService(),
      ),
      child: const _LoginViewBody(),
    );
  }
}

class _LoginViewBody extends StatelessWidget {
  const _LoginViewBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary
                    .withValues(alpha: 0.06),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient:
                              const LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryLight,
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: const Icon(
                          Icons
                              .directions_run_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        'Catat Lari',
                        style:
                            GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  const Text(
                    'Selamat\nDatang Kembali 👋',
                    style: TextStyle(
                      color:
                          AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.w800,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Masuk dan lanjutkan perjalanan larimu',
                    style: TextStyle(
                      color:
                          AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 36),

                  Form(
                    key: vm.formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller:
                              vm.emailController,
                          label: 'Email',
                          hint:
                              'contoh@email.com',
                          prefixIcon:
                              Icons.email_outlined,
                          keyboardType:
                              TextInputType
                                  .emailAddress,
                          validator: (v) {
                            if (v == null ||
                                v.trim()
                                    .isEmpty) {
                              return 'Email tidak boleh kosong';
                            }

                            if (!v.contains(
                              '@',
                            )) {
                              return 'Email tidak valid';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        CustomTextField(
                          controller: vm
                              .passwordController,
                          label: 'Password',
                          hint: '••••••••',
                          prefixIcon: Icons
                              .lock_outline_rounded,
                          obscureText: vm
                              .obscurePassword,
                          suffixIcon:
                              IconButton(
                            icon: Icon(
                              vm.obscurePassword
                                  ? Icons
                                      .visibility_outlined
                                  : Icons
                                      .visibility_off_outlined,
                              color: AppColors
                                  .textSecondary,
                              size: 20,
                            ),
                            onPressed:
                                vm.togglePassword,
                          ),
                          validator: (v) {
                            if (v == null ||
                                v.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }

                            return null;
                          },
                        ),

                        if (vm.errorMessage !=
                            null) ...[
                          const SizedBox(
                            height: 14,
                          ),

                          _ErrorBanner(
                            message:
                                vm.errorMessage!,
                          ),
                        ],

                        const SizedBox(
                          height: 24,
                        ),

                        CustomButton(
                          text: 'Masuk',
                          isLoading:
                              vm.isLoading,
                          icon: Icons
                              .login_rounded,
                          onPressed:
                              () async {
                            final success =
                                await vm
                                    .login();

                            if (!context
                                .mounted) {
                              return;
                            }

                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const DashboardView(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun?',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 14,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const RegisterView(),
                            ),
                          );
                        },
                        child: const Text(
                          'Daftar Sekarang',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _DemoAccounts(
                    onTap: vm.fillDemo,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.error
            .withValues(alpha: 0.08),
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error
              .withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoAccounts extends StatelessWidget {
  final void Function(
    String email,
    String pass,
  ) onTap;

  const _DemoAccounts({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accounts = [
      (
        'Reza Pratama',
        'reza@gmail.com',
        'reza123',
      ),
      (
        'Sari Dewi',
        'sari@gmail.com',
        'sari123',
      ),
      (
        'Budi Santoso',
        'budi@gmail.com',
        'budi123',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color:
                    AppColors.textSecondary,
                size: 14,
              ),

              const SizedBox(width: 6),

              Text(
                'Akun Demo — tap untuk isi otomatis',
                style:
                    GoogleFonts.plusJakartaSans(
                  color: AppColors
                      .textSecondary,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ...accounts.map(
            (a) {
              return GestureDetector(
                onTap: () {
                  onTap(
                    a.$2,
                    a.$3,
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration:
                            BoxDecoration(
                          color: AppColors
                              .primary
                              .withValues(
                            alpha: 0.12,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            8,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            a.$1[0],
                            style:
                                const TextStyle(
                              color: AppColors
                                  .primary,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            a.$1,
                            style:
                                const TextStyle(
                              color: AppColors
                                  .textPrimary,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),

                          Text(
                            '${a.$2}  •  ${a.$3}',
                            style:
                                const TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}