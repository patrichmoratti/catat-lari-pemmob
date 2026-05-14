import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/auth/register_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../dashboard/dashboard_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(
        AuthService(),
      ),
      child: const _RegisterViewBody(),
    );
  }
}

class _RegisterViewBody extends StatelessWidget {
  const _RegisterViewBody();

  @override
  Widget build(BuildContext context) {
    final vm =
        context.watch<RegisterViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),
          child: Form(
            key: vm.formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.all(18),
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
                        24,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors
                              .primary
                              .withValues(
                            alpha: 0.25,
                          ),
                          blurRadius: 25,
                          offset:
                              const Offset(
                            0,
                            10,
                          ),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Buat Akun Baru 🚀',
                  style: TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Mulai perjalanan larimu bersama Catat Lari',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 36),

                CustomTextField(
                  controller:
                      vm.nameController,
                  label: 'Nama Lengkap',
                  hint: 'Nama kamu',
                  prefixIcon: Icons
                      .person_outline_rounded,
                  validator: (v) {
                    if (v == null ||
                        v.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }

                    if (v.trim().length <
                        2) {
                      return 'Nama minimal 2 karakter';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

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
                        v.trim().isEmpty) {
                      return 'Email tidak boleh kosong';
                    }

                    if (!RegExp(
                      r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                    ).hasMatch(
                      v.trim(),
                    )) {
                      return 'Format email tidak valid';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller:
                      vm.phoneController,
                  label: 'Nomor Telepon',
                  hint: '08xxxxxxxxxx',
                  prefixIcon:
                      Icons.phone_outlined,
                  keyboardType:
                      TextInputType.phone,
                  validator: (v) {
                    if (v == null ||
                        v.trim().isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }

                    if (v.trim().length <
                        10) {
                      return 'Nomor telepon tidak valid';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: vm
                      .passwordController,
                  label: 'Password',
                  hint:
                      'Min. 6 karakter',
                  prefixIcon: Icons
                      .lock_outline_rounded,
                  obscureText:
                      vm.obscurePassword,
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
                    ),
                    onPressed:
                        vm.togglePassword,
                  ),
                  validator: (v) {
                    if (v == null ||
                        v.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }

                    if (v.length < 6) {
                      return 'Password minimal 6 karakter';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: vm
                      .confirmPasswordController,
                  label:
                      'Konfirmasi Password',
                  hint:
                      'Ulangi password',
                  prefixIcon: Icons
                      .lock_outline_rounded,
                  obscureText: vm
                      .obscureConfirmPassword,
                  suffixIcon:
                      IconButton(
                    icon: Icon(
                      vm.obscureConfirmPassword
                          ? Icons
                              .visibility_outlined
                          : Icons
                              .visibility_off_outlined,
                      color: AppColors
                          .textSecondary,
                    ),
                    onPressed: vm
                        .toggleConfirmPassword,
                  ),
                  validator: (v) {
                    if (v == null ||
                        v.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }

                    if (v !=
                        vm.passwordController
                            .text) {
                      return 'Password tidak cocok';
                    }

                    return null;
                  },
                ),

                if (vm.errorMessage !=
                    null) ...[
                  const SizedBox(
                    height: 16,
                  ),

                  _ErrorBanner(
                    message:
                        vm.errorMessage!,
                  ),
                ],

                const SizedBox(height: 28),

                CustomButton(
                  text:
                      'Daftar Sekarang',
                  isLoading:
                      vm.isLoading,
                  icon: Icons
                      .person_add_rounded,
                  onPressed:
                      () async {
                    final success =
                        await vm
                            .register();

                    if (!context
                        .mounted) {
                      return;
                    }

                    if (success) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const DashboardView(),
                        ),
                        (_) => false,
                      );
                    }
                  },
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: GoogleFonts
                          .plusJakartaSans(
                        color: AppColors
                            .textSecondary,
                        fontSize: 14,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child:
                          const Text(
                        'Masuk',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
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