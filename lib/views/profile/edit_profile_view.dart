import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/profile/edit_profile_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileViewModel(
        AuthService(),
      )..init(),
      child: const _EditProfileViewBody(),
    );
  }
}

class _EditProfileViewBody extends StatelessWidget {
  const _EditProfileViewBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: vm.formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 200),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        vm.avatarInitial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const _SectionHeader(
                  'Informasi Pribadi',
                ),

                const SizedBox(height: 14),

                CustomTextField(
                  controller: vm.nameController,
                  label: 'Nama Lengkap',
                  hint: 'Nama kamu',
                  prefixIcon:
                      Icons.person_outline_rounded,
                  validator: (v) {
                    if (v == null ||
                        v.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }

                    if (v.trim().length < 2) {
                      return 'Nama minimal 2 karakter';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: vm.emailController,
                  label: 'Email',
                  hint: 'contoh@email.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType:
                      TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null ||
                        v.trim().isEmpty) {
                      return 'Email tidak boleh kosong';
                    }

                    if (!RegExp(
                      r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                    ).hasMatch(v.trim())) {
                      return 'Format email tidak valid';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: vm.phoneController,
                  label: 'Nomor Telepon',
                  hint: '08xxxxxxxxxx',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null ||
                        v.trim().isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }

                    if (v.trim().length < 10) {
                      return 'Nomor telepon tidak valid';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                const _SectionHeader(
                  'Keamanan',
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: vm.changePassword
                        ? AppColors.primary
                            .withValues(alpha: 0.08)
                        : AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(14),
                    border: Border.all(
                      color: vm.changePassword
                          ? AppColors.primary
                              .withValues(alpha: 0.3)
                          : AppColors.cardBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        color: vm.changePassword
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),

                      const SizedBox(width: 12),

                      Text(
                        'Ganti Password',
                        style: TextStyle(
                          color: vm.changePassword
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),

                      const Spacer(),

                      Switch(
                        value: vm.changePassword,
                        onChanged:
                            vm.toggleChangePassword,
                      ),
                    ],
                  ),
                ),

                if (vm.changePassword) ...[
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller:
                        vm.passwordController,
                    label: 'Password Baru',
                    hint: 'Min. 6 karakter',
                    prefixIcon:
                        Icons.lock_outline_rounded,
                    obscureText:
                        vm.obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        vm.obscurePassword
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,
                      ),
                      onPressed:
                          vm.togglePassword,
                    ),
                    validator: (v) {
                      if (vm.changePassword) {
                        if (v == null ||
                            v.isEmpty) {
                          return 'Password baru tidak boleh kosong';
                        }

                        if (v.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    controller:
                        vm.confirmPasswordController,
                    label:
                        'Konfirmasi Password Baru',
                    hint: 'Ulangi password baru',
                    prefixIcon:
                        Icons.lock_outline_rounded,
                    obscureText:
                        vm.obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        vm.obscureConfirmPassword
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,
                      ),
                      onPressed: vm
                          .toggleConfirmPassword,
                    ),
                    validator: (v) {
                      if (vm.changePassword) {
                        if (v == null ||
                            v.isEmpty) {
                          return 'Konfirmasi password tidak boleh kosong';
                        }

                        if (v !=
                            vm.passwordController
                                .text) {
                          return 'Password tidak cocok';
                        }
                      }

                      return null;
                    },
                  ),
                ],

                if (vm.errorMessage != null) ...[
                  const SizedBox(height: 14),

                  Text(
                    vm.errorMessage!,
                    style: const TextStyle(
                      color: AppColors.error,
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                CustomButton(
                  text: 'Simpan Perubahan',
                  isLoading: vm.isLoading,
                  icon: Icons.save_rounded,
                  onPressed: () async {
                    final success =
                        await vm.save();

                    if (!context.mounted) return;

                    if (!success) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Profil berhasil diperbarui!',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;

  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius:
                BorderRadius.circular(2),
          ),
        ),

        const SizedBox(width: 8),

        Text(
          text,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}